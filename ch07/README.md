
normal mapping : normal map을 이용하여 조명을 계산하는 기법.

normal map : 각 픽셀에 사용할 법선 정보를 담고 있는 텍스쳐.

단위벡터가 1이라도, (-1, 0, 0)과 같은게 있으므로, 정규화된 법선벡터의 범위는 : -1 ... 1


N(rgb) = 0.5 * N(xyz) + 0.5
N(xyz) =   2 * N(rgb) -   1


XYZ
Z : 정점의 법선(NORMAL)
X : U나 V중하나를 찝음(접선 : TANGENT)
Y : X cross Y(종법선 : BINORMAL)


  열기준
  | Tx Ty Tz |
  | Bx By Bz |
  | Nx Ny Nz |

  행기준
  | Tx Bx Nx |
  | Ty By Ny |
  | Yz Bz Nz |
