Class {
	#name : 'DFMosquito',
	#superclass : 'CMAgent',
	#instVars : [
		'isInfected',
		'hasBlood',
		'perceptionRadius',
		'ageMax',
		'currentAge',
		'incubationPeriod',
		'reproductionPeriod',
		'nbMosquitoesPerBite',
		'targetBreedingSite'
	],
	#category : 'DengueFever-Model',
	#package : 'DengueFever-Model'
}

{ #category : 'accessing' }
DFMosquito >> ageMax [
<parameterIntegerMin: 0 max: 100 default: 21 >
	^ ageMax
]

{ #category : 'accessing' }
DFMosquito >> ageMax: anObject [

	ageMax := anObject
]

{ #category : 'as yet unclassified' }
DFMosquito >> bite: aDFHuman [ 
	
	self isInfected ifTrue: [ aDFHuman incubationPeriod: 5]
	ifFalse: [ aDFHuman isInfected ifTrue: [ incubationPeriod :=10]].
	hasBlood := true.
	reproductionPeriod := 2.
]

{ #category : 'as yet unclassified' }
DFMosquito >> computeNearestBreedingSite [
	| visited frontier nextFrontier found |
	visited := Set new.
	visited add: self cell.
	frontier := self cell neighbourhood.

	[ frontier isEmpty ] whileFalse: [
		found := frontier detect: [ :c | c hasWater ] ifNone: [ nil ].
		found ifNotNil: [ ^ found ].

		visited addAll: frontier.
		nextFrontier := OrderedCollection new.
		frontier do: [ :c |
			nextFrontier addAll: (c neighbourhood reject: [ :n | visited includes: n ]) ].
		frontier := nextFrontier asSet asOrderedCollection ].

	^ nil.
]

{ #category : 'accessing' }
DFMosquito >> currentAge [

	^ currentAge
]

{ #category : 'accessing' }
DFMosquito >> currentAge: anObject [

	currentAge := anObject
]

{ #category : 'accessing' }
DFMosquito >> flyToBreedingSite [
    | arrived |
    (targetBreedingSite isNil or: [ targetBreedingSite hasWater not ])
        ifTrue: [ targetBreedingSite := self computeNearestBreedingSite ].
    targetBreedingSite ifNil: [ self randomWalk. ^ false ].
    arrived := self cell = targetBreedingSite.
    arrived
        ifTrue: [ targetBreedingSite := nil ]
        ifFalse: [ self moveTowards: targetBreedingSite ].
    ^ arrived
]

{ #category : 'accessing' }
DFMosquito >> flyToHuman [
	| human |
	human := self nearestHuman.
	human isNil
		ifTrue: [ self randomWalk ]
		ifFalse: [
			 self moveTowards: human cell ].
	^human.
]

{ #category : 'accessing' }
DFMosquito >> hasBlood [

	^ hasBlood
]

{ #category : 'accessing' }
DFMosquito >> hasBlood: anObject [

	hasBlood := anObject
]

{ #category : 'accessing' }
DFMosquito >> incubationPeriod [

	^ incubationPeriod
]

{ #category : 'accessing' }
DFMosquito >> incubationPeriod: anObject [

	incubationPeriod := anObject
]

{ #category : 'initialization' }
DFMosquito >> initialize [ 
	super initialize.
	isInfected := self random < 0.5.
	hasBlood:= false.
	ageMax:= 21.
	currentAge :=0.
	incubationPeriod:= nil.
	nbMosquitoesPerBite:= 10.
	targetBreedingSite := nil.
	reproductionPeriod:=0.	
]

{ #category : 'accessing' }
DFMosquito >> isInfected [

	^ isInfected
]

{ #category : 'accessing' }
DFMosquito >> isInfected: anObject [

	isInfected := anObject
]

{ #category : 'accessing' }
DFMosquito >> nbMosquitoesPerBite [
<parameterIntegerMin: 0 max: 100 default: 1 >
	^ nbMosquitoesPerBite
]

{ #category : 'accessing' }
DFMosquito >> nbMosquitoesPerBite: anObject [

	nbMosquitoesPerBite := anObject
]

{ #category : 'accessing' }
DFMosquito >> nearestHuman [
	| candidates|
	candidates := (self cormasModel allEntitiesOfClass: DFHuman)
		select: [ :h | h cell notNil and: [ (self cell distanceTo: h cell) <= 5 ] ].
	^ candidates
		ifEmpty: [ ^nil ]
		ifNotEmpty: [ candidates detectMin: [ :h | self cell distanceTo: h cell ] ].
]

{ #category : 'accessing' }
DFMosquito >> perceptionRadius [
<parameterIntegerDefault: 2>
	^ perceptionRadius
]

{ #category : 'accessing' }
DFMosquito >> perceptionRadius: anObject [

	perceptionRadius := anObject
]

{ #category : 'accessing' }
DFMosquito >> pov [
	<pov> 
	|color|
	color := CMColor black.
	isInfected ifTrue: [ color := CMColor red ].
	^ CMPointOfView 
	color: color
	shape: #circle size: 0.2.
]

{ #category : 'as yet unclassified' }
DFMosquito >> reproduce [
    "Reproduce every reproductionPeriod steps if on breeding site"
    (self cell hasWater and: [ self currentTimeStep \\ reproductionPeriod = 0 ])
        ifTrue: [
				self create: nbMosquitoesPerBite randomlyLocatedEntitiesOfClass: DFMosquito.
		 ].
]

{ #category : 'accessing' }
DFMosquito >> reproductionPeriod [

	^ reproductionPeriod
]

{ #category : 'accessing' }
DFMosquito >> reproductionPeriod: anObject [

	reproductionPeriod := anObject
]

{ #category : 'accessing' }
DFMosquito >> stepMosquito [
    | human |
    currentAge := currentAge + 1.
    currentAge >= ageMax ifTrue: [ self delete. ^self ].

    incubationPeriod isNil ifFalse: [
        incubationPeriod := incubationPeriod - 1.
        incubationPeriod = 0 ifTrue: [
            self isInfected: true.
            incubationPeriod := nil ] ].

		reproductionPeriod > 0 ifTrue: [ 
      reproductionPeriod := reproductionPeriod - 1.
        ^ self ].

    hasBlood ifFalse: [
        self cell hasWater
            ifTrue: [ self randomWalk ]
            ifFalse: [
                human := self flyToHuman.
                human ifNotNil: [ self bite: human ] ] ].
]

{ #category : 'accessing' }
DFMosquito >> targetBreedingSite [

	^ targetBreedingSite
]

{ #category : 'accessing' }
DFMosquito >> targetBreedingSite: anObject [

	targetBreedingSite := anObject
]
