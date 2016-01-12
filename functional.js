barWidgetCount = widgets.filter((widget) => widget.get('type') == 'bar')
	.reduce((acc, widget) => acc + widget.get('count'));
