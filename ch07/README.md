
normal mapping : normal map을 이용하여 조명을 계산하는 기법.

normal map : 각 픽셀에 사용할 법선 정보를 담고 있는 텍스쳐.

단위벡터가 1이라도, (-1, 0, 0)과 같은게 있으므로, 정규화된 법선벡터의 범위는 : -1 ... 1

    N(rgb) = 0.5 * N(xyz) + 0.5
    N(xyz) =   2 * N(rgb) -   1


* XYZ
 - Z : 정점의 법선(NORMAL)
 - X : U나 V중하나를 찝음(접선 : TANGENT)
 - Y : X cross Y(종법선 : BINORMAL)


    열기준
    | Tx Ty Tz |
    | Bx By Bz |
    | Nx Ny Nz |

    행기준
    | Tx Bx Nx |
    | Ty By Ny |
    | Yz Bz Nz |


법선맵핑의 문제점중 하나 : 측면에서 보면 입체감이 떨어진다.
parallax mapping - normal map에다 height map을 이용하여 문제를 해결하려함.
parallax occlusion mapping : + 인접픽셀과의 높이차를 구한후, 그에 따른 그림자를 입히는 기법.
 - GPU gems, Shader X 참고.
