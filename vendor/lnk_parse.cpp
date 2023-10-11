//
// Created by shawn on 2022/7/21.
//
# include <shlobj.h>
# include <iostream>
# include <cstdlib>

using namespace std;
//参数1：Lnk文件路径，参数2：返回存放目标路径

bool GetShellPath(const char *Src, char *result, int cch) {
    ::CoInitialize(NULL); //初始化COM接口
    IShellLink *psl = NULL;
    //创建COM接口，IShellLink对象创建
    HRESULT hr = CoCreateInstance(CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, IID_IShellLink, (LPVOID *) &psl);
    if (SUCCEEDED(hr)) {
        IPersistFile *ppf;
        hr = psl->QueryInterface(IID_IPersistFile, (LPVOID *) &ppf);
        if (SUCCEEDED(hr)) {
            WCHAR wsz[MAX_PATH];
            MultiByteToWideChar(CP_ACP, 0, Src, -1, wsz, MAX_PATH);    //转下宽字节
            hr = ppf->Load(wsz, STGM_READ);    //加载文件
            if (SUCCEEDED(hr)) {
                WIN32_FIND_DATA wfd;
                hr = psl->GetArguments(result, cch);
                if (SUCCEEDED(hr)) {
                    return true;
                }
            }
            ppf->Release();
        }
        psl->Release();  //释放对象
    }
    ::CoUninitialize();   //释放COM接口
    return false;
}

int main(int argc, char const *argv[]) {
    if (argc < 2) {
        cerr << "Please specify a windows lnk file" << endl;
        exit(1);
    }
    const char *lnkfile = argv[1];
    const char *p;
//    char *lnkfile = "C:\\Users\\shawn\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Anaconda3 (64-bit)\\Anaconda Prompt (miniconda).lnk";
//    p = lnkfile;
//    while (*p != '\0') {
//        cout << *p++;
//    }
//    cout << endl;
    char *arguments = new char[128];
    bool flag = GetShellPath(lnkfile, arguments, 128);
    if (flag) {
        p = arguments;
        while (*p != '\0') {
            cout << *p++;
        }
        cout << endl;
        delete[] arguments;
    } else {
        cerr << "cannot get arguments from the given lnk file: \""<< argv[1] << "\"" << endl;
        delete[] arguments;
        exit(1);
    }
}
