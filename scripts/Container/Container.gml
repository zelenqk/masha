function Container(style = {}, p = self) : ContainerUtil(p) constructor{
	properties = style;
	main = parse_calculations(properties);
	
	if (root == self) render();
}