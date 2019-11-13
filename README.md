셰이더 프로그래밍 입문
=============================

http://www.hanbit.co.kr/book/look.html?isbn=978-89-7914-949-4

![셰이더 프로그래밍 입문](http://image.hanbit.co.kr/cover/_m_1949m.gif)

한빛미디어에서 반값 할인 하기에 지름 ㅇㅇ.



# 프로그램.
* 책 소스
 - http://www.hanbit.co.kr/exam/1949/source.zip

* 렌더몽키
 - http://developer.amd.com/tools-and-sdks/archive/legacy-cpu-gpu-tools/rendermonkey-toolsuite/

* Visual Studio C++ express
 - http://www.visualstudio.com/downloads/download-visual-studio-vs

* DirectX Software Development Kit
 - http://www.microsoft.com/en-us/download/details.aspx?id=6812



# 문제해결
* DirectX SDK (June 2010) 설치할 때 Error Code S1023
 - ref: http://appmaid.tistory.com/11

1. 기존 Visual C++ 2010 X86/X64 Redistributable Package 제거.
2. DirectX SDK 설치.
3. 최신 버전의 Visual C++ 2010 X86/X64 Redistributable Package 설치.
 - http://www.microsoft.com/ko-kr/download/details.aspx?id=26999

* LNK1123 에러
 - ref: http://ejnahc.tistory.com/412

1. Microsoft Visual C++ 2010 Service Pack 1 재배포 가능 패키지 설치.
 - https://www.microsoft.com/en-us/download/confirmation.aspx?id=23691


# TODO
텍스쳐
빛과 반사
lambert
phong

toon shader
outline
hatching
diffuse map / light map / normal map / specular map
environment map(sphere map/ cube map)
water wave
volume shadow - 9-con sampling
mosaic
noise - square, diamond, graphic patterns, jigsaw
voronoi diagram - NPR(Non Realistic Rendering)
perturbation - embossed glass
pencil stroke
distortion
hatching
blur
bloom
