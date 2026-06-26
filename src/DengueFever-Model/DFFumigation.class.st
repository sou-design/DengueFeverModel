Class {
	#name : 'DFFumigation',
	#superclass : 'CMAgent',
	#instVars : [
		'breedingSites',
		'radius'
	],
	#category : 'DengueFever-Model',
	#package : 'DengueFever-Model'
}

{ #category : 'accessing' }
DFFumigation >> breedingSites [

	^ breedingSites
]

{ #category : 'accessing' }
DFFumigation >> breedingSites: aCollection [

	breedingSites := aCollection
]

{ #category : 'initialization' }
DFFumigation >> initialize [ 
	super initialize.
	radius := 4.
]

{ #category : 'as yet unclassified' }
DFFumigation >> pov [
	<pov> 
	|color|
	color := Color yellow alpha: 0.5. 
	^ CMPointOfView 
		color: color
		shape: #circle size: 6

]

{ #category : 'as yet unclassified' }
DFFumigation >> stepFumigation [
    | toKill target allCells |
    breedingSites isEmpty ifTrue: [ self randomWalk. ^ self ].
    
    target := breedingSites atRandom.
    allCells := target neighbourhood copyWith: target.
    self moveTo: allCells atRandom.
    self moveTo: allCells atRandom.
    self moveTo: allCells atRandom.
    
    toKill := (self cormasModel allEntitiesOfClass: DFMosquito)
        select: [ :m | (self cell distanceTo: m cell) <= radius ].
    toKill do: [ :m | m delete ].
]
