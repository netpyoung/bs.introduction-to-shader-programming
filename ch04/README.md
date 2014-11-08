
specular 정반사
diffuse 난반사



local illumination model : 직접광만 다루는 조명모델.
global illumination model : 간접광까지 다루는 조명모델


람베르트 모델(http://en.wikipedia.org/wiki/Lambertian_reflectance)
난반사광 = 표면법선(normal)과 입사광이 이루는 각의 cos.



	x = A와 B가 이루는 각도
	|A| = 방향 벡터 A의 길이.
	|B| = 방향 벡터 B의 길이.
	A dot B = cos x |A||B|


동일한 계산을 어느쪽에서도 할 수 있다면, 픽셀셰이더 보다는, 정점셰이더를 이용.


셰이더 프로그래밍시, 용도에 딱 맞는 시맨틱이 없는 경우가 종종 있는데, 이때 TEXCOORD를 사용하는게 일반적임.


saturate() : 0이하의 값을 0으로, 1이상의 값을 1으로변경.(성능 영향없음)



---

정반사광
퐁 모델(http://en.wikipedia.org/wiki/Phong_reflection_model)


reflect(입사광 방향벡터, 반사면 법선)
코사인 값을 거듭제곱함으로써 구함.



Blinn-Phong : 퐁과 거의 비슷한 기법(현재도 많이 사용)
Oren-Nayar : 표면의 거친 정도를 고려한 난반사광 조명기법.
Cook-Torrance : 포면의 거친 정도를 고려한 정반사광 조명기법.
spherical harmonics lighting : 오프라인에서 간접광을 사전 처리한뒤, 실시간으로 이를 주변광으로 적용할 때 사용할 수 있음.