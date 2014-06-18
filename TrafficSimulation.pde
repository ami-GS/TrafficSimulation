//マルチエージェントシミュレータ 
// レベル2　+ 食べ物・体力を回復の概念を導入
// by Hajime Nobuhara

int Length = 400; //空間管理配列の大きさ
int All_Human = 400;
int Max_Human = 25; //シミュレータに登場させる人間の数

//空間管理配列を準備
int[][] MAP = new int[Length][Length]; 
int[][] subMAP = new int[Length/20][Length/20]; 
int[] seqMAP = new int[(Length/20)*(Length/20)];
int TIME = 0;
int slowNum = 10;
int virus = 10;
int infection = 100;
int newCommer = 100;
int changeSpeed = 20;
//int step = 1;
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
     //if(random(1000) < virus){k1 = 2;}
     int k2 = int(random(100,width-100)); //登場する初期 x座標
     int k3 = int(random(height)); //登場する初期 y座標
     int k4 = int(random(5)); //人間の動作方向をランダムにセット
     int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
     int k6 = 2000 + int(random(200)); //200~400の範囲で体力をセット
     //int step = int(random(1,4));
     int step = 3;
     if(random(1000) < slowNum){step = 2;k1=2;}
     Human.add(new Human_class(k1,k2,k3,k4,k5,k6, step,i));
  }
  
  //空間の状態管理配列を初期化
}



//
// メインループ
//

void draw() {

  println("sub");  
  for(int i=0; i < 5; i++){
    for(int j = 0; j < 20; j++){
      print(subMAP[i][j], "");
    }
    println();
  }
  
  if(random(1000) < newCommer && subMAP[0][0] == 0){
     int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
     int step = int(random(2,4));
     if(random(1000) < slowNum){step = 3;k1=2;}  
     for(int i = 0; i < Max_Human; i++){
       Human_class h = (Human_class)Human.get(i);
       h.seqPosition += 1;
     }  
     Human.add(0, new Human_class(k1,1,1,1,1,10,step, 0));
     Max_Human += 1;
  }
  
 //背景を描画
 makeground();


  //人間を動かす
/*  for(int j=Max_Human-1; j >= 0; j--){
    Human_class h = (Human_class)Human.get(j);
       int coll = h.drive();
       if(coll == 1 && j != Max_Human-1){//if collide
         Human_class hNext = (Human_class)Human.get(j+1);
         if(hNext.type == 2 && random(100) < infection){
           h.setType(2);
         }
     }
  }*/
  //h.drive();

 //人間を描画
 for(int j=0; j < Max_Human; j++){
  Human_class h = (Human_class)Human.get(j);
  //生きている人間だけ処理  
     h.timer ++;  //人間の体内時計を1つカウントアップ
     //人間を描画
     //アニメーションを使っており、体内時計に合わせて動く
     h.draw(); 
     h.drive();
     if(random(1000) < changeSpeed){h.step += int(random(-1,1));}
/*     h.hp = h.hp - 1; //1単位時間で体力を1減らす

     if(h.hp < 0){
       h.type = 0;  //もし体力が0になったら、状態を死に変更
       MAP[h.xpos][h.ypos] = 0;  //状態管理の配列から消去
       Human.remove(j);
       j--;
       Max_Human--;
     }*/
   //}
  if(floor(h.ypos/20)*20+(20-floor(h.xpos/20)) == Length){
    //MAP[floor(h.ypos/20)*20+(floor(h.xpos/20))] = 0;
    subMAP[floor(h.ypos/20)][floor(h.xpos/20)] = 0;
    Human.remove(j);
    j--;
    Max_Human--;
  }
 }
 
  for(int i=0; i<20; i++){
    for(int j = 0; j < 20; j++){
      subMAP[i][j] = 0;
    }
  } 
 
 for(int i=0; i < Max_Human; i++){
   Human_class h = (Human_class)Human.get(i);
   subMAP[floor(h.ypos/20)][floor(h.xpos/20)] = h.type;
 }
  
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
  int step;
  int seqPosition;
  boolean upFlag = false;
  boolean fromDown = false;
  boolean downFlag = false;
  boolean fromUp = false;
  Human_class(int c, int xp, int yp, int dirt, int t, int h, int st, int seq) {
    xpos = xp;
    ypos = yp;
    type = c;
    direction = dirt;
    timer = t;
    hp = h;
    step = st;
    seqPosition = seq;
    if(floor(seq/20)%2 == 0){xpos = (seq%20)*20+1;}
    else{xpos = Length-(seq%20)*20-1;}
    ypos = floor(seq/20)*20;//+10;
    subMAP[floor(ypos/20)][floor(xpos/20)] = c; 
  }

  void setType(int t){
    type = t;
  }


 //人間を描画する部分
  void draw () {
 
    smooth();
    noStroke();
    
    //体力によって色を変更しましょう
    
    if(type == 1){
    fill(100,255,255); //健康な状態
    }
    else if(type == 2){fill(250, 100,100);}    
       
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
    
    
    //動く方向4方向 + 何も動かない
    //合計5種類を準備

      int tmpx = floor(xpos / 20);
      int tmpy = floor(ypos / 20);

      int tx = xpos, ty = ypos;
      if(tmpy % 2 == 0 || tmpx == 0){direction=1;}//right
      else if(tmpy % 2 == 1 || tmpx == 19){direction=2;}//lefght
      if((tmpy % 2 == 0 && tmpx == 19) || (tmpy % 2 == 1 && tmpx == 0)){direction=3;}//down

      switch(direction){
      case 0:
        break; //何も動かず
    
      case 1:
          //tx = xpos;
          xpos += step;
          
          if(tmpx != floor(xpos/20) && subMAP[tmpy][tmpx+1] == 0){
            subMAP[tmpy][tmpx] = 0;
            subMAP[tmpy][floor(xpos/20)] = type;            
          }
          else if(tmpx != floor(xpos/20) && subMAP[tmpy][tmpy+1] != 0){
            if(subMAP[tmpy][tmpy+1] == 2 && random(100) < infection){
                setType(2);
              }
            xpos = tx;
        }
          break;
          
      case 2:
          //tx = xpos;
          xpos -= step;
          if(tmpx != floor(xpos/20) && subMAP[tmpy][tmpx-1] == 0){
            subMAP[tmpy][tmpx] = 0;
            subMAP[tmpy][floor(xpos/20)] = type;            
          }
          else if(tmpx != floor(xpos/20) && subMAP[tmpy][tmpx-1] != 0){
            if(subMAP[tmpy][tmpx-1] == 2 && random(100) < infection){
                setType(2);
              }            
            xpos = tx;
          }
          break;
          
      case 3:
          MAP[xpos][ypos] = 0;
          //ty = ypos;
          ypos += step;
          if(tmpx == 0){
            if(tmpy != floor(ypos/20) && subMAP[tmpy+1][tmpx] == 0){
              subMAP[tmpy][tmpx] = 0;
              subMAP[floor(ypos/20)][tmpx] = type;
            }
            else if(tmpy != floor(ypos/20) && subMAP[tmpy+1][tmpx] != 0){
              ypos = ty;
            }            
          }
          else if(tmpx == 19){
            if(tmpy != floor(ypos/20) && subMAP[tmpy+1][tmpx] == 0){
              subMAP[tmpy][tmpx] = 0;
              subMAP[floor(ypos/20)][tmpx] = type;
            }
            else if(tmpy != floor(ypos/20) && subMAP[tmpy+1][tmpx] != 0){
              ypos = ty;
            }            
          }

          break;
      
      }     

     return;
      }
}


//背景を描画
void makeground(){
  fill(110,110,110);
 //ちょっと薄めのグリーン
  rect(0,0,width,height);  
  for(int i = 0; i < 20; i++){
    fill(200,200,200);
    if(i%2 == 0){
    fill(140,140,110);
    rect(25,i*20,width-25, 20);
    fill(200,200,200);
    rect(25,20*i,Length-25,2); //<>//
    }
    else{
    rect(0,20*i,Length-25,2);
    }
  }
  fill(140,110,140);
  rect(5,height-5,20,5);
}

void mousePressed() {
 saveFrame("human3.png"); 
}
