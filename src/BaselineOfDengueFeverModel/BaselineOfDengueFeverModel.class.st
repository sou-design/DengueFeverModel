Class {
	#name : 'BaselineOfDengueFeverModel',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDengueFeverModel',
	#package : 'BaselineOfDengueFeverModel'
}

{ #category : 'baselines' }
BaselineOfDengueFeverModel >> baseline: spec [

	<baseline>
	spec for: #common do: [

		"Packages"
		spec
			package: 'DengueFever-Model';
			package: 'DengueFever-Tests' with: [ spec requires: #( 'DengueFever-Model' ) ] ]
]
