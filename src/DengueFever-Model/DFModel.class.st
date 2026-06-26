Class {
	#name : 'DFModel',
	#superclass : 'CMModel',
	#instVars : [
		'numberOfMosquitoes',
		'numberOfHumans',
		'humans',
		'mosquitoes',
		'ageMax',
		'fumigationRadius',
		'nbFumigations'
	],
	#category : 'DengueFever-Model',
	#package : 'DengueFever-Model'
}

{ #category : 'as yet unclassified' }
DFModel >> ageMax [
    <parameterIntegerMin: 10 max: 100 default: 21 >
    ^ ageMax
]

{ #category : 'as yet unclassified' }
DFModel >> ageMax: aValue [
    ageMax := aValue.
    (self allEntitiesOfClass: DFMosquito)
        do: [ :m | m ageMax: aValue ].

]

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
DFModel >> fumigationRadius [
    <parameterIntegerMin: 1 max: 10 default: 4 >
    ^ fumigationRadius
]

{ #category : 'accessing' }
DFModel >> fumigationRadius: aValue [
    fumigationRadius := aValue.
    (self allEntitiesOfClass: DFFumigation)
        do: [ :m | m radius: aValue ].

    
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

{ #category : 'initialization' }
DFModel >> initializeFumigation [
    1 to: 4 do: [ :i |
        | f |
        f := self newEntity: DFFumigation.
        f moveTo: ((self allEntitiesOfClass: DFCell) select: [ :c | c hasWater ]) atRandom ].
]

{ #category : 'initialization' }
DFModel >> initializePatrolZones [
    | waterCells chunk |
    waterCells := ((self allEntitiesOfClass: DFCell )
        select: [ :c | c hasWater ]) asOrderedCollection.
    chunk := waterCells size // nbFumigations .
    1 to: nbFumigations do: [ :i |
        | f assignedCells |
        f := self newEntity: DFFumigation.
        assignedCells := waterCells 
            copyFrom: (i - 1) * chunk + 1 
            "last fumigation takes remaining cells"
            to: (i = 4 ifTrue: [ waterCells size ] ifFalse: [ i * chunk ]).
        f breedingSites: assignedCells.
        f moveTo: assignedCells first ].
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
DFModel >> mosquitoesOnWater [
    <probeNamed: 'Mosquitoes On Water' color: '0000FF'>
    ^ (self allEntitiesOfClass: DFMosquito)
        count: [ :m | m cell hasWater ]
]

{ #category : 'as yet unclassified' }
DFModel >> mosquitoesWithBlood [
    <probeNamed: 'Mosquitoes With Blood' color: 'FF0000'>
    ^ (self allEntitiesOfClass: DFMosquito)
        count: [ :m | m hasBlood ]
]

{ #category : 'as yet unclassified' }
DFModel >> nbFumigations [
    <parameterIntegerMin: 1 max: 6 default: 4 >
    ^ nbFumigations
]

{ #category : 'as yet unclassified' }
DFModel >> nbFumigations: aValue [
    nbFumigations := aValue.
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfHumans [
	<parameterIntegerMin: 0 max: 100 default: 40 >
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
DFModel >> numberOfInfectedMosquitoes [
	<probeNamed: 'Infected mosquitoes' color: 'B659A2'>
	^ (self allEntitiesOfClass: DFMosquito) count: [ :each| each isInfected ].
]

{ #category : 'as yet unclassified' }
DFModel >> numberOfMosquitoes [ 
	<parameterIntegerMin: 0 max: 100 default: 20 >
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

{ #category : 'as yet unclassified' }
DFModel >> numberOfNonInfectedMosquitoes [
	<probeNamed: 'Non infected mosquitoes' color: '16A085'>
	^ (self allEntitiesOfClass: DFMosquito) count: [ :each| each isInfected not].
]

{ #category : 'accessing' }
DFModel >> prefix [
	"Every class name in model package must begin with this prefix"
	^ 'DF'.
]

{ #category : 'as yet unclassified' }
DFModel >> randomPos [
    ^ self pickRandomCellConstrainedBy: [ :aCell | aCell type = #city ]
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
                        newMosquito moveTo: each cell. newMosquito randomJump ].
                    each hasBlood: false ]. ] ].
	self @@ DFHuman do: [ :each | each step].
       "deploy fumigation only when mosquitoes > 200"
    (self allEntitiesOfClass: DFMosquito) size > 200
        ifTrue: [
            (self allEntitiesOfClass: DFFumigation) isEmpty
                ifTrue: [ self initializePatrolZones ] ].
    (self allEntitiesOfClass: DFFumigation) copy
        do: [ :each | each stepFumigation ].
]
