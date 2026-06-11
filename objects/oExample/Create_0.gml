test = new Container({
	width: 300,
	height: 200,
	
	background: sStoyanKolev2,
	
	hover: {
		background: sStoyanKolev	
	},
	
	hold: {
		tint: c_red,
	}
})

wtf = test.add({
	width: "100%",
	height: 32,
	
	background: c_blue,
});

wtf = test.add({
	width: "100%",
	height: 32,
	
	background: c_blue,
});

wtf = test.add({
	width: "100%",
	height: 32,
	
	background: c_blue,
});

text = new TextSystem();
text.render();