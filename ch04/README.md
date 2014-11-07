
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