//precision mediump float;
//
//void main()
//{
//    gl_FragColor = vec4(1.0, 0.5, 0.5, 1.0);
//}


precision mediump float;

varying vec4 vDestinationColor;

void main()
{
    gl_FragColor = vDestinationColor;
}
