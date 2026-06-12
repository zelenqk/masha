test = new Container({
<<<<<<< HEAD
	width: 300,
	height: 200,
	
	gap: 6,
	
	background: c_red,
});

test.add({
	width: "100%",
	height: 32,
	background: sStoyanKolev,
});

test.add({
	width: "100%",
	height: 32,
	background: c_blue,
});

test.add({
	width: "100%",
	height: 32,
	background: c_blue,
=======
	width: "50%",
	height: "50%",
	
	background: c_red,
	overflow: fa_hidden,
	
	hover: {
		background: sStoyanKolev,
	},
	
	hold: {
		background: sStoyanKolev,
		image: 1,
		weight: 1
	}
>>>>>>> 9b41c21 (optimizations + refactoring)
});