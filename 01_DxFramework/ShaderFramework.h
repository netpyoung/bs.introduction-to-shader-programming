//**********************************************************************
//
// ShaderFramework.h
// 
// ���̴� ���� ���� C��Ÿ���� �ʰ��� �����ӿ�ũ�Դϴ�.
// (���� ������ �ڵ��Ͻ� ���� ���� �̷��� �����ӿ�ũ��
// �ۼ��Ͻø� �ȵ˴ϴ�. -_-)
//
// Author: Pope Kim
//
//**********************************************************************


#pragma once

#include <d3d9.h>
#include <d3dx9.h>

// ---------- ���� ------------------------------------
#define WIN_WIDTH		800
#define WIN_HEIGHT		600

// ---------------- �Լ� ������Ÿ�� ------------------------

// �޽��� ó���� ����
LRESULT WINAPI MsgProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam );
void ProcessInput(HWND hWnd, WPARAM keyPress);

// �ʱ�ȭ ����
bool InitEverything(HWND hWnd);
bool InitD3D(HWND hWnd);
bool LoadAssets();
LPD3DXEFFECT LoadShader( const char * filename );
LPDIRECT3DTEXTURE9 LoadTexture(const char * filename);
LPD3DXMESH LoadModel(const char * filename);

// ���ӷ��� ����
void PlayDemo();
void Update();

// ������ ����
void RenderFrame();
void RenderScene();
void RenderInfo();

// ������ ����
void Cleanup();
