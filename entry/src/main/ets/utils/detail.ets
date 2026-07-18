import { AxiosResponse } from '@ohos/axios'
import { AxiosUtil } from './AxiosUtils';
import { showToken } from "ets/utils/preferences";

export interface Response {
  code: number
  message: string
  data?: Request[]
}

export interface Request {
  status?: number
  id?:number
  account?: string
  gid?: number
  content?: string
  creation_date?: Date
}


export async function GetDetailFunction(groupid: number): Promise<Response> {
  const testAxios = AxiosUtil.instance
  const account = showToken()[0]
  const params: Request = { account: account, gid: groupid }
  const response: AxiosResponse<Response> = await testAxios.get("/catrun/detail/get", { params })
  return response.data
}

export async function AddDetailFunction(groupid: number, content: string): Promise<Response> {
  const testAxios = AxiosUtil.instance
  const account = showToken()[0]
  const body: Request = { account: account, gid: groupid, content: content }
  const response: AxiosResponse<Response> = await testAxios.post("/catrun/detail/add", body)
  console.info("添加代办成功：", JSON.stringify(response.data))
  return response.data
}

export async function ExchangeDetailFunction(id: number, content: string, status: number): Promise<Response> {
  const testAxios = AxiosUtil.instance
  const body: Request = { id: id, content: content, status: status }
  const response: AxiosResponse<Response> = await testAxios.put("/catrun/detail/exchange", body)
  console.info("代办状态操作成功：", JSON.stringify(response.data))
  return response.data
}

export async function RemoveDetailFunction(id: number): Promise<Response> {
  const testAxios = AxiosUtil.instance;
  const account = showToken()[0]
  const body: Request = { account: account, id: id }
  const res: AxiosResponse<Response> = await testAxios.delete("/catrun/detail/remove", {
    data: body
  });
  return res.data
}

@CustomDialog
export struct AddDetailDialog {
  controller?: CustomDialogController;
  @State TempContent: string = ''
  @State EnterContent: string = ''
  @Prop x: number
  @Require callback:()=> void

  build() {
    Column({ space: 16 }) {
      Row() {
        TextInput({ placeholder: '代办名称' })
          .type(InputType.Normal)
          .backgroundColor(Color.Transparent)
          .placeholderFont({ size: 20 })
          .placeholderColor('#ffcbcbcb')
          .borderRadius(0)
          .fontSize(20)
          .padding({ left: 0, right: 0 })
          .defaultFocus(true)
          .layoutWeight(1)
          .onChange((value) => {
            this.TempContent = value
          })
        Button() {
          Image($r('app.media.enter')).width(26).fillColor('#fff')
        }
        .backgroundColor('#ac9698')
        .width(52)
        .height(36)
        .borderRadius(6)
        .enabled(!!this.TempContent)
        .onClick(async () => {
          this.EnterContent = this.TempContent
          const data: Response = await AddDetailFunction(this.x, this.EnterContent)
          this.callback()
          this.controller?.close()
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .backgroundColor('#fff')
    .padding(24)
  }
}


