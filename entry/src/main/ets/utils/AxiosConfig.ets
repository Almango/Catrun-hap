import { Env } from "./config";

export class AxiosConfig{
  private static readonly ENV: Env = Env.pro // 环境选择

  // 服务器地址（本机局域网IP，鸿蒙模拟器通过该IP访问宿主）
  // static readonly BASE_URL: string = 'http://10.0.2.2:';
  private static readonly DEV_BASE_URL: string = "https://xxapi.cn" //虚拟机使用
  private static readonly TEST_BASE_URL: string = "https://xxapi.cn"//预览器使用
  private static readonly PRO_BASE_URL:string = "http://10.0.2.2:"  //生产环境使用
  // 端口
  private static readonly PORT: string = "3000"; //外部接口,不知道端口;可以访问,估么着是允许所有端口访问
  // 接口前缀
  private static readonly API_PREFIX: string = '/api';
  // 超时时间
  static readonly TIME_OUT: number = 3000;
  static readonly ENABLE_MOCK: boolean = false;



  static getFullBaseUrl() {
    switch (AxiosConfig.ENV) {
      case Env.dev://dev    虚拟机使用
        return AxiosConfig.DEV_BASE_URL + AxiosConfig.PORT + AxiosConfig.API_PREFIX;
      case Env.test://test  预览器使用
        return AxiosConfig.TEST_BASE_URL + AxiosConfig.PORT + AxiosConfig.API_PREFIX;
      case Env.pro://test   生产环境使用
        return AxiosConfig.PRO_BASE_URL + AxiosConfig.PORT + AxiosConfig.API_PREFIX;
    }
  }
}