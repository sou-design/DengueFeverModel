Class {
	#name : 'DFHuman',
	#superclass : 'CMAgent',
	#instVars : [
		'isInfected',
		'incubationPeriod',
		'homeCell',
		'workCell'
	],
	#category : 'DengueFever-Model',
	#package : 'DengueFever-Model'
}

{ #category : 'accessing' }
DFHuman >> commute [
    "1 day = 4 steps: 0=night, 1=morning, 2=afternoon, 3=evening"
    | dayStep |
    dayStep := self currentTimeStep \\ 4.
    
    dayStep = 1 ifTrue: [ self moveTo: workCell ].
    dayStep = 3 ifTrue: [ self moveTo: homeCell ].

	"self moveTowards: self workCell"
]

{ #category : 'accessing' }
DFHuman >> homeCell [

	^ homeCell
]

{ #category : 'accessing' }
DFHuman >> homeCell: anObject [

	homeCell := anObject
]

{ #category : 'accessing' }
DFHuman >> incubationPeriod [

	^ incubationPeriod
]

{ #category : 'accessing' }
DFHuman >> incubationPeriod: anObject [

	incubationPeriod := anObject
]

{ #category : 'accessing' }
DFHuman >> initialize [
	super initialize.
	isInfected :=false.
"	self selectHomeCell.
	self selectWorkCell."
]

{ #category : 'accessing' }
DFHuman >> isInfected [

	^ isInfected
]

{ #category : 'accessing' }
DFHuman >> isInfected: anObject [

	isInfected := anObject
]

{ #category : 'accessing' }
DFHuman >> pov [
	<pov> 
	|color|
	color := CMColor blue.
	isInfected ifTrue: [ color := CMColor red ].
	^ CMPointOfView 
		color: color
		shape: #star size: 0.8
]

{ #category : 'accessing' }
DFHuman >> randomStep [ 
	self randomWalk.
	self updateState.
]

{ #category : 'as yet unclassified' }
DFHuman >> selectHomeCell [
    | cityCells index |
    cityCells := (self cormasModel allEntitiesOfClass: DFCell) select: [ :c |
        c type = #city].
    index := (self randomBetween: 1 and: (cityCells size))asInteger.
    ^ cityCells at: index
]

{ #category : 'as yet unclassified' }
DFHuman >> selectWorkCell [
    | cityCells index |
    cityCells := (self cormasModel allEntitiesOfClass: DFCell) select: [ :c |
        c type = #city and: [ c ~= homeCell ] ].
    cityCells isEmpty ifTrue: [ ^ homeCell ].
    index := (self randomBetween: 1 and: cityCells size) asInteger.
    ^ cityCells at: index
]

{ #category : 'accessing' }
DFHuman >> step [

	self commute.
	self updateState
]

{ #category : 'as yet unclassified' }
DFHuman >> updateState [

	^ incubationPeriod isNil ifFalse: [
			  incubationPeriod := incubationPeriod - 1.
			  incubationPeriod = 0 ifTrue: [
					  self isInfected: true.
					  incubationPeriod := nil ] ]
]

{ #category : 'accessing' }
DFHuman >> workCell [

	^ workCell
]

{ #category : 'accessing' }
DFHuman >> workCell: anObject [

	workCell := anObject
]
