Class {
	#name : 'DFModel',
	#superclass : 'CMModel',
	#instVars : [
		'numberOfMosquitoes',
		'numberOfHumans',
		'humans',
		'mosquitoes'
	],
	#category : 'DengueFever-Model',
	#package : 'DengueFever-Model'
}

{ #category : 'as yet unclassified' }
DFModel >> applyStatesFromMatrix: aMatrix [
    | rows cols value cell |
    rows := aMatrix size.
    cols := aMatrix first size.
    1 to: rows do: [ :i |
        1 to: cols do: [ :j |
            cell := self cellAt: i at: j.
            value := (aMatrix at: i) at: j.
            value = 1 ifTrue: [ cell type: #vegetation. cell hasWater: false ].
            value = 2 ifTrue: [ cell type: #city. cell hasWater: false ].
            value = 3 ifTrue: [ cell type: #city. cell hasWater: true ]]].
 
]

{ #category : 'accessing' }
DFModel >> humans [

	^ humans
]

{ #category : 'accessing' }
DFModel >> humans: anObject [

	humans := anObject
]

{ #category : 'as yet unclassified' }
DFModel >> init [
	<init>
	self makeAgentsScatteredInCells.
	
	self
		createGridNumberOfRows: 30
		numberOfColumns: 30
		neighbourhood: 4
		closed: true.
		
	self applyStatesFromMatrix: self stateMatrix.
	
	humans:= OrderedCollection new.
	mosquitoes := OrderedCollection new.
	humans addAll: (self create: numberOfHumans randomlyLocatedEntitiesOfClass: DFHuman).
	humans do: [ :h |
    h homeCell: h selectHomeCell.
	h workCell: h selectWorkCell .
    h moveTo: h homeCell].
	mosquitoes :=self create: numberOfMosquitoes randomlyLocatedEntitiesOfClass: DFMosquito.

]

{ #category : 'as yet unclassified' }
DFModel >> maxMosquitoAge [
    <probeNamed: 'Max Mosquito Age' color: '1565C0'>
    | all |
    all := self allEntitiesOfClass: DFMosquito.
    all isEmpty ifTrue: [ ^ 0 ].
    ^ all max: [ :each | each currentAge ]
]

{ #category : 'as yet unclassified' }
DFModel >> modelName [
	"A human-friendly name of the model"
	^ 'DengueFever'
]

{ #category : 'as yet unclassified' }
DFModel >> mosquitoes [
    <probeNamed: 'Mosquitoes Number' color: 'B90E0A'>
    ^ (self allEntitiesOfClass: DFMosquito) size
]

{ #category : 'accessing' }
DFModel >> mosquitoes: anObject [

	mosquitoes := anObject
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfHumans [
	<parameterIntegerMin: 0 max: 100 default: 20 >
	^ numberOfHumans 
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfHumans: anObject [

	numberOfHumans := anObject
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfInfectedHumans [
	<probeNamed: 'Infected humans' color: '2E7D32'>
	^ self humans count: [ :each| each isInfected ].
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfMosquitoes [ 
	<parameterIntegerMin: 0 max: 100 default: 5 >
	^ numberOfMosquitoes  
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfMosquitoes: anObject [

	numberOfMosquitoes := anObject
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfNonInfectedHumans [
	<probeNamed: 'Non Infected humans' color: '9B59B6'>
	^ self humans count: [ :each| each isInfected not ].
]

{ #category : 'accessing' }
DFModel >> prefix [
	"Every class name in model package must begin with this prefix"
	^ 'DF'.
]

{ #category : 'accessing' }
DFModel >> stateMatrix [
    "1 = vegetation, 2 = city, 3 = city with water"
    ^ #(
        (1 2 2 2 1 1 2 1 1 1 1 2 2 2 2 1 1 3 3 2 2 1 2 2 2 1 1 1 1 1)
        (2 1 2 2 2 1 1 1 3 1 1 2 2 2 1 3 3 3 2 2 2 2 1 2 2 1 1 1 1 1)
        (1 2 2 1 2 1 1 1 1 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 2 1 1 1 2)
        (1 2 1 2 1 1 1 1 1 2 2 3 3 3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 2 2)
        (1 2 2 2 1 1 1 1 2 2 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2)
        (2 2 2 2 1 1 2 2 2 3 3 3 3 2 1 1 2 2 2 2 2 2 2 2 3 1 1 1 2 2)
        (1 2 2 1 1 2 2 2 2 3 3 3 2 2 1 1 2 2 2 2 2 2 1 2 3 3 1 1 2 2)
        (1 2 2 2 2 1 2 2 2 3 2 2 2 1 1 1 1 2 2 2 2 2 2 2 1 1 1 1 2 2)
        (1 1 2 2 2 2 2 2 3 3 3 2 2 2 2 2 1 3 3 3 2 2 3 3 2 2 2 2 2 1)
        (1 2 2 2 2 2 2 2 3 2 3 2 2 2 2 2 1 2 2 2 2 3 3 3 2 2 2 2 2 1)
        (1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 2 2 2 2 2 1)
        (2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 2 2 2 2 2 2 2 2 1)
        (2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 1 3 3 3 3 2 2 2 2 2 2 2 2 2 1)
        (2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 2 2 2 1)
        (2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2)
        (2 2 2 2 2 2 2 3 3 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2)
        (1 2 2 2 2 2 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2)
        (2 2 2 2 2 3 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 2 2 2)
        (2 2 3 3 3 3 2 1 1 2 2 2 2 2 2 3 2 2 2 2 2 2 2 2 1 1 1 1 2 2)
        (2 2 3 3 3 3 2 1 2 2 2 2 2 2 2 3 2 2 2 2 2 3 3 2 2 1 1 1 2 2)
        (2 2 2 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 2 2 2 2 1 1 2 2 2)
        (2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2)
        (2 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 2 2)
        (1 1 1 2 2 2 1 2 2 2 3 3 3 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 1 2)
        (1 2 3 2 2 2 2 1 1 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1)
        (1 2 2 2 2 2 2 2 1 3 3 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 2 2)
        (1 2 2 2 2 2 2 2 2 2 3 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 2 2 2 2)
        (1 2 2 2 2 2 2 2 1 3 2 2 2 2 2 2 2 2 2 2 1 2 2 2 2 2 2 1 2 2)
        (1 2 2 2 2 2 1 1 1 1 1 2 2 2 2 2 2 2 2 1 1 1 1 2 1 2 1 3 3 2)
        (1 2 1 2 2 1 1 1 1 1 1 1 2 3 3 3 1 2 1 1 1 1 1 1 3 3 3 3 3 1)
    ) 
]

{ #category : 'as yet unclassified' }
DFModel >> step [
    <control>
    (self allEntitiesOfClass: DFMosquito) copy
        do: [ :each | each stepMosquito ].
    (self allEntitiesOfClass: DFMosquito) copy
        do: [ :each |
            each hasBlood ifTrue: [
                each flyToBreedingSite ifTrue: [
                    each nbMosquitoesPerBite timesRepeat: [
                        | newMosquito |
                        newMosquito := self newEntity: DFMosquito.
                        newMosquito moveTo: each cell ].
                    each hasBlood: false ] ] ].
    self @@ DFHuman do: [ :each | each step ].
]
