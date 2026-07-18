import { AxiosResponse } from '@ohos/axios'
import { AxiosUtil } from './AxiosUtils';

export interface Request {
  account: string
  type: string
  code?: string
}

export interface TokenRequest {
  accessToken: string,
  refreshToken: string
  expiresIn: number
}

export interface Response<T> {
  code: number
  message: string
  data: T
}

// 获取验证码专用
export async function GetVerifyCode(account: string): Promise<Response<Request>> {
  const testAxios = AxiosUtil.instance
  const req: Request = { account, type: "send" }
  const res: AxiosResponse<Response<Request>> = await testAxios.post("/catrun/auth/signin_code", req)
  return res.data
}

// 验证码登录专用
export async function LoginByCode(account: string, code: string): Promise<Response<TokenRequest>> {
  const testAxios = AxiosUtil.instance
  const req: Request = { account, type: "login", code: code }
  const res: AxiosResponse<Response<TokenRequest>> = await testAxios.post("/catrun/auth/signin_code", req)
  return res.data
}
