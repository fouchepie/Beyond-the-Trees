extends Camera2D


var ZOOM_MIN = 1.05
var ZOOM_MAX = 1.3
var SCALE_MIN = 1.12
var SCALE_MAX = 1.4


func zoom_out(delta):
	zoom = Vector2(ZOOM_MAX, ZOOM_MAX)
	$CloudAnimation.scale = Vector2(SCALE_MIN, SCALE_MIN)
	$CloudAnimation.frame = 0

	$CloudAnimation.play('cloud_giant')
	while $CloudAnimation.is_playing() or zoom.x > ZOOM_MIN:

		zoom = clamp(zoom, Vector2(ZOOM_MIN,ZOOM_MIN), Vector2(ZOOM_MAX,ZOOM_MAX))
		var zoom_factor = (ZOOM_MAX - ZOOM_MIN) / (2 / delta) # distance of zoom to do / number of zoom updates
		zoom -= Vector2(zoom_factor, zoom_factor)
		
		$CloudAnimation.scale = clamp($CloudAnimation.scale, Vector2(SCALE_MIN,SCALE_MIN), Vector2(SCALE_MAX,SCALE_MAX))
		var scale_factor = (SCALE_MAX - SCALE_MIN) / (2 / delta)
		$CloudAnimation.scale += Vector2(scale_factor, scale_factor)
		
		await get_tree().create_timer(delta).timeout


func zoom_in(delta):
	zoom = Vector2(ZOOM_MIN, ZOOM_MIN)
	$CloudAnimation.scale = Vector2(SCALE_MAX, SCALE_MAX)
	$CloudAnimation.frame = 0
	
	$CloudAnimation.play_backwards('cloud_giant')
	while $CloudAnimation.is_playing() or zoom.x < ZOOM_MAX:

		zoom = clamp(zoom, Vector2(ZOOM_MIN,ZOOM_MIN), Vector2(ZOOM_MAX,ZOOM_MAX))
		var zoom_factor = (ZOOM_MAX - ZOOM_MIN) / (2 / delta) # distance of zoom to do / number of zoom updates
		zoom += Vector2(zoom_factor, zoom_factor)
		
		$CloudAnimation.scale = clamp($CloudAnimation.scale, Vector2(SCALE_MIN,SCALE_MIN), Vector2(SCALE_MAX,SCALE_MAX))
		var scale_factor = (SCALE_MAX - SCALE_MIN) / (2 / delta)
		$CloudAnimation.scale -= Vector2(scale_factor, scale_factor)
		
		await get_tree().create_timer(delta).timeout

