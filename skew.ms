plugin simpleMod skewy
name:"skewy"
classID:#(0x6b15953d, 0xb0cf3d07)
version:1.1
( 
	parameters main rollout:main
	(
		skewAxis type:#integer ui:uiSkewAxis default:3
		skewAmount type:#worldUnits ui:uiSkewAmount default:0
		skewDirection type:#float ui:uiSkewDirection default:0
		LimitEnabled type:#boolean ui:uiLimitEnabled default:false
		LimitMax type:#worldUnits ui:uiLimitMax default:0
		LimitMin type:#worldUnits ui:uiLimitMin default:0
	)

	rollout main "MyBend Parameters"
	(
		group "Skew:"
		(
			spinner uiSkewAmount "Amount: " type:#worldUnits range:[-1e9,1e9,0] scale:.01 offset:[0,4]
			spinner uiSkewDirection "Direction: " range:[-1e9,1e9,0] scale:1
		)
		group "Skew Axis:"
		(
			radiobuttons uiSkewAxis "" labels:#("X","Y","Z") columns:3 align:#center offsets:#([-7,0],[0,0],[7,0])
		)
		group "Limits"
		(
			checkbox uiLimitEnabled "Limit Effect" align:#right offset:[9,0]
			spinner uiLimitMax "Upper Limit" range:[0,1e9,0] type:#worldUnits
			spinner uiLimitMin "Lower Limit" range:[-1e9,0,0] type:#worldUnits
		)
	)

	on map i p do
	(
		if LimitEnabled then
		(
			case of
			(
				(p[skewAxis] > LimitMax): skewVal = (skewAmount*LimitMax/(LimitMax-LimitMin))
				(p[skewAxis] < LimitMin):  skewVal = (skewAmount*LimitMin/(LimitMax-LimitMin))
				default: skewVal = (skewAmount*p[skewAxis]/(LimitMax-LimitMin))
			)
		)
		else
			skewVal = (skewAmount*p/extent)[skewAxis]
		case skewAxis of
		(
			1: (p + ([0,0,skewVal] * (rotateXMatrix (180-skewDirection))))
			2: (p + ([0,0,skewVal] * (rotateYMatrix (-skewDirection+90))))
			default: (p + ([0,skewVal,0] * (rotateZMatrix (-skewDirection-90))))
		)		
	)
)
