//マルチエージェントシミュレータ 
// レベル2　+ 食べ物・体力を回復の概念を導入
// by Hajime Nobuhara

int Length = 400; //空間管理配列の大きさ
int All_Human = 400;
int Max_Human = 200; //シミュレータに登場させる人間の数

//空間管理配列を準備
int[][] MAP = new int[Length][Length]; 
int[][] subMAP = new int[Length/20][Length/20]; 
int TIME = 0;
//人間の配列を準備
ArrayList Human = new ArrayList<Human_class>();


//初期化部
void setup() {
  colorMode(RGB);
  size(Length, Length);
  background(0);
  frameRate(30);

  //ここで人間を生成
  for(int i=0; i < Max_Human; i++){
     int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
     int k2 = int(random(21,width-20)); //登場する初期 x座標
     int k3 = int(random(height)); //登場する初期 y座標
     int k4 = int(random(5)); //人間の動作方向をランダムにセット
     int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
     int k6 = 2000 + int(random(200)); //200~400の範囲で体力をセット
     Human.add(new Human_class(k1,k2,k3,k4,k5,k6));
  }
  
  //空間の状態管理配列を初期化
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }
}



//
// メインループ
//

void draw() {
 
 //背景を描画
 makeground();

 //人間を描画
 for(int j=0; j < Max_Human; j++){
  Human_class h = (Human_class)Human.get(j);
  //生きている人間だけ処理  
   if(h.type == 1){
     h.timer ++;  //人間の体内時計を1つカウントアップ
     //人間を描画
     //アニメーションを使っており、体内時計に合わせて動く
     h.draw(); 
     
     h.hp = h.hp - 1; //1単位時間で体力を1減らす

     if(h.hp < 0){
       h.type = 0;  //もし体力が0になったら、状態を死に変更
       MAP[h.xpos][h.ypos] = 0;  //状態管理の配列から消去
       Human.remove(j);
       j--;
       Max_Human--;
     }
   }
 }

  //人間を動かす
  for(int j=0; j < Max_Human; j++){
    Human_class h = (Human_class)Human.get(j);
     if(h.type == 1){
       h.drive();
     }
  }
  
  /*
  //お互いの衝突判定
  for(int j=0; j < Max_Human; j++){
    Human_class h = (Human_class)Human.get(j);
    if(h.type == 1){
     h.coll();
    }
  }*/
  
  TIME++;
}



//
// 人間のクラスを定義
//

class Human_class
{

  int xpos; //x座標
  int ypos; //y座標
  int type; //人間の状態
  int direction; //人間の動作方向
  int timer; //体内時計
  int hp; //体力
  boolean upFlag = false;
  boolean fromDown = false;
  Human_class(int c, int xp, int yp, int dirt, int t, int h) {
    xpos = xp;
    ypos = yp;
    type = c;
    direction = dirt;
    timer = t;
    hp = h;
  }



 //人間を描画する部分
  void draw () {
 
    smooth();
    noStroke();
    
    //体力によって色を変更しましょう
    
    
    fill(100,255,255); //健康な状態
    
    if(hp < 100){
      fill(40,255,255); //体力が落ち始めた状態
    }
  
    if(hp < 50){
       fill(10,255,255); //危険な状態
    }   
       
    //アニメーションは全部で5種類準備
    //体内時間を5で割って、その余りに応じて
    //表示するアニメを決定
    
    int time = timer % 5;
    switch(time){
      
      case 0:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5); //胴体
        rect(xpos-3,ypos+8,3,5); //左足
        rect(xpos-4,ypos+3,2,5); //左腕
        rect(xpos+2,ypos+3,2,5); //右腕
    
        break;
      case 1:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,4);
        rect(xpos,ypos+8,3,1);        
        break;
       case 2:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,3);
        rect(xpos,ypos+8,3,3);
        break;
        case 3:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,1);
        rect(xpos,ypos+8,3,4);
        break;
        case 4:
        
        //5枚目
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos,ypos+8,3,5);
        rect(xpos-4,ypos+3,2,5); 
        rect(xpos+2,ypos+3,2,5); 
        break;
        
    }
  }


//人間を動かす部分
  void drive () {
    
    //確率5%で動く方向を変更
    //if(random(100) < 5){
      //5種類の動きをランダムにセット
   //   direction = int(random(5));
    //}
    
    //動く方向4方向 + 何も動かない
    //合計5種類を準備
    /*
    switch(direction){
      case 0:
        break; //何も動かず
    
      case 1:
          MAP[xpos][ypos] = 0;
          xpos = (xpos + 1 + width) % width; //右に動かす
          break;
          
      case 2:
          MAP[xpos][ypos] = 0;
          xpos = (xpos - 1 + width) % width; //左に動かす
          break;
          
      case 3:
          MAP[xpos][ypos] = 0;
          ypos = (ypos + 1 + height) % height; //下に動かす
          break;
      
     case 4:
          MAP[xpos][ypos] = 0;
          ypos = (ypos - 1 + height) % height; //上に動かす
          break;
    }
     
   
   //自分の移動先に存在を代入
     MAP[xpos][ypos] = type;  */
     
     
     
      int tmpx = floor(xpos / 20);
      int tmpy = floor(ypos / 20);

      if(!upFlag){
       if(tmpy % 2 == 0){
        direction = 1;
      }
      else{
        direction = 2;
      }
      if((tmpx == 0 || tmpx == 19) && !fromDown){
        direction = 4;
        upFlag = true;
      }
        
      switch(direction){
      case 0:
        break; //何も動かず
    
      case 1:
          MAP[xpos][ypos] = 0;
          xpos = (xpos + 1 + width) % width; //右に動かす
          fromDown = false;
          if(tmpx != floor(xpos/20)){
            subMAP[tmpx][tmpy] = 0;
          }
          break;
          
      case 2:
          MAP[xpos][ypos] = 0;
          xpos = (xpos - 1 + width) % width; //左に動かす
          fromDown = false;
          if(tmpx != floor(xpos/20)){
            subMAP[tmpx][tmpy] = 0;
          }
          break;
          
      case 3:
          MAP[xpos][ypos] = 0;
          ypos = (ypos + 1 + height) % height; //下に動かす
          if(tmpy != floor(ypos/20)){
            subMAP[tmpx][tmpy] = 0;
          }
          break;
      
     case 4:
          MAP[xpos][ypos] = 0;
          ypos = (ypos - 1 + height) % height; //上に動かす
          if(tmpy != floor(ypos/20)){
            subMAP[tmpx][tmpy] = 0;
          }
          break; 
      }     
      }
      else{
          MAP[xpos][ypos] = 0;
          //print("(", ypos);
          ypos = (ypos - 1 + height) % height; //上に動かす
          //print(" ", ypos, ")");
          //print("(",tmpy, ypos%20,")");
//          print(tmpy, floor(ypos/20), " ");
          if(tmpy != floor(ypos/20)){
            //          print(tmpy, floor(ypos/20), " ");
            subMAP[tmpx][tmpy] = 0;
            upFlag = false;
            fromDown = true;
          }
    }
      
     subMAP[xpos%20][ypos%20] = type;
      }
}


//背景を描画
void makeground(){
  fill(150,110,110);
 //ちょっと薄めのグリーン
  rect(0,0,width,height);  
}

void mousePressed() {
 saveFrame("human3.png"); 
}
