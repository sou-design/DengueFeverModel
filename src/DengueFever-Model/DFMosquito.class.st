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
	
	self isInfected ifTrue: [ aDFHuman incubationPeriod: 1]
	ifFalse: [ aDFHuman isInfected ifTrue: [ incubationPeriod :=2]].
	hasBlood := true.
	reproductionPeriod := 2.
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
    | arrived mosquitoesOnCell breedingSites |
    (targetBreedingSite isNil or: [ targetBreedingSite hasWater not ]) ifTrue: [
        breedingSites := (self cormasModel allEntitiesOfClass: DFCell)
            select: [ :c | c hasWater ].
        breedingSites isEmpty ifTrue: [ self randomWalk. ^ false ].
        targetBreedingSite := breedingSites atRandom ].
    arrived := self cell = targetBreedingSite.
    arrived
        ifTrue: [
            mosquitoesOnCell := (self cormasModel allEntitiesOfClass: DFMosquito)
                select: [ :o | o cell = targetBreedingSite ].
            mosquitoesOnCell size > 5 ifTrue: [
                targetBreedingSite := nil. ^ false ].
            targetBreedingSite := nil. ]
        ifFalse: [ 10 timesRepeat: [self moveTo: targetBreedingSite] ].
    ^ arrived
]

{ #category : 'accessing' }
DFMosquito >> flyToHuman [
    | human |
    self randomWalk.
    human := (self cormasModel allEntitiesOfClass: DFHuman)
        detect: [ :h | h cell = self cell or: [ self cell neighbourhood includes: h cell ] ]
        ifNone: [ self randomWalk ].
    ^ human.
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
	nbMosquitoesPerBite:= 1.
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
    | humans |
    humans := self cormasModel allEntitiesOfClass: DFHuman.
    humans isEmpty ifTrue: [ ^ nil ].
    ^ humans detectMin: [ :h | self cell distanceTo: h cell ].
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
    currentAge >= ageMax ifTrue: [ ^ self delete ].

    incubationPeriod isNil ifFalse: [
        incubationPeriod := incubationPeriod - 1.
        incubationPeriod = 0 ifTrue: [
            self isInfected: true.
            incubationPeriod := nil ] ].

    hasBlood ifFalse: [
        self cell hasWater
            ifTrue: [ self randomWalk ]
            ifFalse: [
                human := self flyToHuman.
                human ifNotNil: [ self bite: human. ] ] ].
]

{ #category : 'accessing' }
DFMosquito >> targetBreedingSite [

	^ targetBreedingSite
]

{ #category : 'accessing' }
DFMosquito >> targetBreedingSite: anObject [

	targetBreedingSite := anObject
]

{ #category : 'as yet unclassified' }
DFMosquito >> updateState [
	
	incubationPeriod isNil ifFalse: [
			  incubationPeriod := incubationPeriod - 1.
			  incubationPeriod = 0 ifTrue: [
					  self isInfected: true.
					  incubationPeriod := nil ] ] 
]
