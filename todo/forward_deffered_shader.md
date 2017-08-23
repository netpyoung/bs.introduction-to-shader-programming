메모리 효율 측면에선 고화질에서 포워드렌더링을 쓰는 게 낫고
동적 광원 모델을 애니메이션 종류나 하드웨어에 구애되지 않고 자유롭게 사용할 수 있다는 것이다.
 앤티얼라이싱을 지원하는 하드웨어에서 어떤 구성요소든 렌더링할 수 있다는 게 장점으로 꼽힌다.

객체에 영향을 주는 모든 광원을 적용해야 결과물이 나온다
문제는 광원이 여러개일 때 각 광원마다 렌더링프로세스 횟수가 늘어나 성능이 급격히 떨어진다

 레벨 디자이너가 포워드렌더링을 적용시 너무 많은 객체에 영향을 주지 않도록 광원을 조절하고 라이트그리드 방식으로 정적 광원을 동적인 것처럼 속이는 기법과 셰이더 처리를 줄이는 방식을 적용할 수 있다


하이폴리곤 처리 효율은 디퍼드렌더링이 낫다
디퍼드렌더링은 많이 사용하는 덩어리를 미리 선처리해서 메모리에 보관해 뒀다가 나중에 재사용하는 방식이다. 이미 계산된 결과를 보관해두고 반복 사용하기 때문에 추가 메모리를 많이 필요로한다.

디퍼드렌더링은 통상적으로 각 픽셀마다 포지션, 노멀, 뎁스, 컬러, 4개 버퍼를 저장하는데,
 하복의 비전 엔진에서는 노멀, 뎁스, 컬러와 어큐멀레이션, 4가지를 쓴다.
 포지션은 픽셀셰이더에서 재구축된다.
 이런 버퍼 구조를 'G버퍼'라 부른다고 킨트는 설명했다.


단점은 어떤 물체가 어떤 표면재질인지 알 수 없이 픽셀값만 계산해야 한다는 것과 수시로 GPU메모리에서 많은 정보를 가져오느라 대역폭이나 용량이 결과물 속도에 영향을 준다는 점이다.




https://www.slideshare.net/agebreak/ndc11-deferred-shading

* foward rendering
  - single pass, multi light

for object in objects:
    for light in lights:
        framebuffer = light_model(object, light);

  - multi pass, multi light

for light in lights:
    for object in apply(light, objects):
        framebuffer = framebuffer + light_model(object, light);

* defered rendering
  - defered shading

for object in objects:
    g-buffer = get_light_properties(object)

for light in lights:
    framebuffer = framebuffer + light_model(g-buffer, light)
