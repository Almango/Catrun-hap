import axios, {
  AxiosError,
  AxiosInstance,
  AxiosInterceptorOptions,
  AxiosResponse,
  InternalAxiosRequestConfig
} from '@ohos/axios'
import { AxiosConfig } from './AxiosConfig';
import { showToken } from './preferences';



const TAG = "[AxiosUtil]"

export class AxiosUtil {
  private static _instance: AxiosInstance | null = null;

  static get instance(): AxiosInstance {
    if (AxiosUtil._instance === null) {
      // 创建Axios实例
      AxiosUtil._instance = axios.create({
        baseURL: AxiosConfig.getFullBaseUrl(),
        timeout: AxiosConfig.TIME_OUT,
        headers: {
          'Content-Type': 'application/json',
        }
      });
      // 这里 id 就不用接收了,是全局默认的拦截器,
      // 注册所有拦截器（请求成功/失败，响应成功/失败）
      AxiosUtil._instance.interceptors.request.use(
        AxiosUtil.requestOnFulfilled,
        AxiosUtil.requestOnRejected,
        AxiosUtil.interceptorOptions
      );
      AxiosUtil._instance.interceptors.response.use(
        AxiosUtil.responseOnFulfilled,
        AxiosUtil.responseOnRejected,
        AxiosUtil.interceptorOptions
      );
    }
    return AxiosUtil._instance
  }

  // ---------- 请求拦截器 ----------
  private static requestOnFulfilled(value: InternalAxiosRequestConfig): InternalAxiosRequestConfig {

    if(!AxiosConfig.ENABLE_MOCK){
      value.headers.Authorization = "Bearer " + showToken()[1]
      console.log("eeeeeeeeeeeee",value.headers.Authorization)
      return value
    }


    // TODO 此处可对请求动手脚,是否正常发送请求，还是走自己的的 "请求适配器"
    // value.adapter = axios.defaults.adapter
    return value
  }



  private static requestOnRejected(error: AxiosError): Promise<never> {
    return Promise.reject(error);
  }

  // ---------- 响应拦截器 ----------
  private static responseOnFulfilled(response: AxiosResponse): AxiosResponse {
    return response;
  }


  private static responseOnRejected(error: AxiosError): Promise<never> {
    return Promise.reject(error);
  }

  // ---------- 拦截器配置 ----------
  private static readonly interceptorOptions: AxiosInterceptorOptions = {
    synchronous: false, // 不同步，异步执行
    runWhen: () => {
      return true // 当前项目不做条件判断，始终执行
    }
  };

  private constructor() {

  }
}