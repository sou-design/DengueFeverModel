Class {
	#name : 'DFCell',
	#superclass : 'CMCell',
	#instVars : [
		'waterLevel',
		'type',
		'hasWater'
	],
	#category : 'DengueFever-Model',
	#package : 'DengueFever-Model'
}

{ #category : 'accessing' }
DFCell >> beCity [
	<action>
	type := #city
]

{ #category : 'accessing' }
DFCell >> beVegetation [
	<action>
	type := #vegetation
]

{ #category : 'accessing' }
DFCell >> hasWater [

	^ hasWater
]

{ #category : 'accessing' }
DFCell >> hasWater: aBoolean [

	hasWater := aBoolean
]

{ #category : 'as yet unclassified' }
DFCell >> initWaterLevel [
	waterLevel := 0.
	type = #vegetation ifTrue: [ waterLevel := self randomBetween: 0 and: 0.4  ].
	type = #city ifTrue: [ waterLevel := self randomBetween: 0 and: 0.33 ].
]

{ #category : 'as yet unclassified' }
DFCell >> initialize [

	super initialize.
	hasWater:=false.
	"self initWaterLevel."
]

{ #category : 'testing' }
DFCell >> isBreedingSite [
	"^ waterLevel > 0.3"
]

{ #category : 'accessing' }
DFCell >> pov [
	<pov>
	| color |
	
	color := CMColor black.
	
	type = #vegetation ifTrue: [ color := CMColor green ].
	type = #city ifTrue: [ color := CMColor gray ].
	hasWater ifTrue: [ color := CMColor fromHexString: '78B9FF' ].
	"self isBreedingSite ifTrue: [ color := CMColor fromHexString: 'F1C40F' ]."

	^ CMPointOfView color: color
]

{ #category : 'accessing' }
DFCell >> type [

	^ type
]

{ #category : 'accessing' }
DFCell >> type: anObject [

	type := anObject
]

{ #category : 'accessing' }
DFCell >> waterLevel [

	^ waterLevel
]

{ #category : 'accessing' }
DFCell >> waterLevel: anObject [

	waterLevel := anObject
]
