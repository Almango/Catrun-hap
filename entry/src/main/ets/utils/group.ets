import { AxiosResponse } from '@ohos/axios'
import {Prompt} from "ets/common/prompt";

import { AxiosUtil } from './AxiosUtils';
import { showToken } from "ets/utils/preferences";

export interface Response<T> {
  code: number;
  message: string;
  data?:T
}

export interface Request {
  id?:number,
  account:string
  title?: string;
  color?: string;
  creation_date?:Date
}

export interface RemoveGroupRequest {
  account:string
  gid:number
}
// 全局公共方法，只拿数据，不操作任何页面状态
export async function FetchGroupList(): Promise<Request[]> {
  try {
    const res = await AllGroupFunction()
    if (res && res.data) {
      return res.data
    }
    return []
  } catch (error) {
    console.error("FetchGroupList 失败：", error)
    return []
  }
}

export async function AddGroupFunction(title: string, color:string): Promise<Response<Request>> {
  const testAxios = AxiosUtil.instance;
  const account = showToken()[0]
  const body: Request = { account: account, title: title, color: color }
  const response: AxiosResponse<Response<Request>> = await testAxios.post("/catrun/group/add", body);
  return response.data
}

export async function AllGroupFunction(): Promise<Response<Request[]>> {
  const testAxios = AxiosUtil.instance;
  const account = showToken()[0]
  const params: Request = { account: account }
  const response: AxiosResponse<Response<Request[]>> = await testAxios.get("/catrun/group/all", { params });
  return response.data
}

export async function RemoveGroupFunction(id: number): Promise<Response<RemoveGroupRequest>> {
  const testAxios = AxiosUtil.instance;
  const account = showToken()[0]
  const body: RemoveGroupRequest = { account: account, gid: id }
  const res: AxiosResponse<Response<RemoveGroupRequest>> = await testAxios.delete("/catrun/group/remove", {
    data: body
  });
  return res.data
}




type SendOut = (promtdata: number) => void
@Entry
@CustomDialog
export struct AddGroupDialog {
  controller?: CustomDialogController;
  retrundata?: SendOut
  @State ColorGroups: string[] = ["#6eb6ff", "#ff84e2cf", "#edb1f1", "#ff9999", "#c3bef0", "#ffd3b6","#e6a4b4"]

  @State TempTitle:string = ''
  @State EnterTitle:string = ''
  @State EnterColor:string = '#ac9698'

  build() {
    Column({ space: 16 }) {
      Row(){
        TextInput({ placeholder: '设置组名称' })
          .type(InputType.Normal)
          .backgroundColor(Color.Transparent)
          .placeholderFont({ size: 20 })
          .placeholderColor('#ffcbcbcb')
          .borderRadius(0)
          .fontSize(20)
          .padding({left:0, right:0})
          .defaultFocus(true).layoutWeight(1)
          .onChange((value)=>{
            this.TempTitle = value
          })
        Button() {
          Image($r('app.media.enter')).width(26).fillColor('#fff')
        }.width(52).height(36).borderRadius(6).enabled(!!this.TempTitle).backgroundColor('#ac9698')
        .onClick(async ()=>{
          this.EnterTitle = this.TempTitle
          const data:Response<Request> = await AddGroupFunction(this.EnterTitle, this.EnterColor)
          if (data.code === 200) {
            this.retrundata?.(data.code)
            this.controller?.close()
          }
          Prompt(this.getUIContext(), data.message)
        })

      }
      Row({space:10}){
        ForEach(this.ColorGroups, (item:string)=>{
          Radio({value:'Color', group:'1'}).width('30').backgroundColor(item).borderRadius(24).margin(0)
            .radioStyle({ checkedBackgroundColor: Color.Transparent})
            .onChange(()=>{
              this.EnterColor = `${item}`
              console.log(item)
            })
        })

      }.width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius({topLeft:12, topRight:12})
    .width('100%')
    .backgroundColor('#fff')
    .padding(24)
  }
}
