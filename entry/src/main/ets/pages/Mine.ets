import {clearToken, showToken} from 'ets/utils/preferences'
import {Prompt} from "ets/common/prompt";


interface funtionItems {
  title: string;      // 功能名称
  color?: string;    // 图标颜色可选
  onClick?: () => void; // 点击回调
}
@Component
export struct Mine {

  private funcData: funtionItems[] = [
    { title: '清空数据',onClick: () => {Prompt(this.getUIContext(), '功能待开发')}},
    { title: '账号管理', onClick: () => {Prompt(this.getUIContext(), '功能待开发')}},
    { title: '通用设置', onClick: () => {Prompt(this.getUIContext(), '功能待开发')}},
    { title: '退出登录', onClick: () => {clearToken(this.getUIContext(), 'pages/Login'); Prompt(this.getUIContext(), '登出成功')}},
  ]


  build() {
    Column({space:15}){
      // 用户头部信息
      Row({space:12}){
        Image('http://q.qlogo.cn/headimg_dl?dst_uin=1830314643&spec=640&img_type=jpg').width(60).borderRadius(6)
        Column({space:10}){
          Row({space:4}){
            Text('管理员01').fontSize(20).fontColor('#524546').fontWeight(FontWeight.Bold)
            // Image($r(`app.media.${getUserdata().sex = 1 ? 'woman' : 'man'}`)).width(24)
          }
          Row({space:10}){
            // Text(getUserdata().desc).fontSize(16).fontColor('#999')
            Text(showToken()[0]).fontSize(16).fontColor('#80826e70')
            // Text('LV.73').fontSize(12).fontColor('#99ddcc').backgroundColor('#ffd6fff4').padding(4).borderRadius(2)
          }
        }.alignItems(HorizontalAlign.Start)
      }.width('100%')

      // 用户社交数据
      Row(){
        Column({space:4}){
          Text('代办').fontSize(15).fontColor('#80826e70')
          Text('10').fontSize(18).fontColor('#826e70')
        }
        Column({space:4}){
          Text('备忘').fontSize(15).fontColor('#80826e70')
          Text('520').fontSize(18).fontColor('#826e70')
        }
        Column({space:4}){
          Text('签到').fontSize(15).fontColor('#80826e70')
          Text('43').fontSize(18).fontColor('#826e70')
        }

      }.width('100%').height(68).backgroundColor('#fff').padding({left:16, right:16}).borderRadius(6).border({width:1, color:'#ffeeeeee'})
      .justifyContent(FlexAlign.SpaceAround)

      // 公告栏
      // Row({space:5}){
      //   Image($r('app.media.broadcast')).width('18').fillColor('#ff653ba9')
      //   Text('大型新版本将在6月30日中午12点同步开启').fontSize(12).fontColor('#ffe470ff').layoutWeight(1).maxLines(1) .textOverflow({ overflow: TextOverflow.Ellipsis })
      //   Text('立即更新').fontSize(12).fontColor('#ff9d66ff')
      // }.width('100%').height(40).backgroundColor('#1ae470ff').borderRadius(10).padding(10)

      // 常用设置
      Column(){
        // 列表UI
        List({space:16}) {
          ListItemGroup() {
            ForEach(this.funcData.filter(item => item.title !== '退出登录'), (item:funtionItems, index)=>{
              ListItem() {
                Row({space:12}) {
                  Text(item.title)
                    .fontSize(16)
                    .fontColor('#826e70')
                    .layoutWeight(1)
                  Image($r('app.media.right'))
                    .width(18)
                    .height(18)
                    .fillColor('#80826e70')
                }
                .onClick(item.onClick)
                .width('100%')
                .padding({ top: 16, bottom: 16 })
              }
            })
          }
          .width('100%')
          .borderRadius(6)
          .backgroundColor('#ffffff')
          .padding({left:16, right:16})
          .divider({ strokeWidth: 1, color: '#fff3f3f3' })

          ListItemGroup() {
            ForEach(this.funcData.filter(item => item.title === '退出登录'), (item:funtionItems, index)=>{
              ListItem() {
                Row({space:12}) {
                  Text(item.title)
                    .fontSize(16)
                    .fontColor('#826e70')
                    .layoutWeight(1)
                  Image($r('app.media.right'))
                    .width(18)
                    .height(18)
                    .fillColor('#80826e70')
                }
                .onClick(item.onClick)
                .width('100%')
                .padding({ top: 16, bottom: 16 })
              }
            })
          }
          .width('100%')
          .borderRadius(6)
          .backgroundColor('#ffffff')
          .border({width:1, color:'#ffeeeeee'})
          .padding({left:16, right:16})
          .divider({ strokeWidth: 1, color: '#fff3f3f3' })
        }

      }
    }.width('100%').height('100%').padding(20)
  }
}