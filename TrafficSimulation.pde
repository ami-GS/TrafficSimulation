//マルチエージェントシミュレータ 
// レベル2　+ 食べ物・体力を回復の概念を導入
// by Hajime Nobuhara

int Length = 400; //空間管理配列の大きさ
int All_Human = 400;
int Max_Human = 25; //シミュレータに登場させる人間の数

//空間管理配列を準備
int[][] subMAP = new int[Length/20][Length/20]; 
int TIME = 0;
int slowNum = 10;
int infection = 100;
int newCommer = 100;
int changeSpeed = 20;
int infecSpeed = 2;
int maxHP = 3000;
int fps = 60;
ArrayList Human = new ArrayList<Human_class>();


//初期化部
void setup() {
  colorMode(RGB);
  size(Length, Length);
  background(0);
  frameRate(fps);

  //ここで人間を生成
  for(int i=0; i < Max_Human; i++){
     int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
     //if(random(1000) < virus){k1 = 2;}
     int x = int(random(100,width-100)); //登場する初期 x座標
     int y = int(random(height)); //登場する初期 y座標
     //int k4 = int(random(5)); //人間の動作方向をランダムにセット
     int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
     int k6 = maxHP + int(random(200)); //1000~1200の範囲で体力をセット
     //int step = int(random(1,4));
     int step = 3;
     if(random(1000) < slowNum){step = infecSpeed;k1=2;}
     Human.add(new Human_class(k1,x,y,k5,k6, step,i));
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
     int step = 3;//int(random(2,4));
     int hp = maxHP + int(random(200));
     if(random(1000) < slowNum){step = infecSpeed;k1=2;}  
     for(int i = 0; i < Max_Human; i++){
       Human_class h = (Human_class)Human.get(i);
       h.seqPosition += 1;
     }  
     Human.add(0, new Human_class(k1,1,1,1,hp,step, 0));
     Max_Human += 1;
  }
  
 //背景を描画
 makeground();

 //人間を描画
 for(int j=0; j < Max_Human; j++){
  Human_class h = (Human_class)Human.get(j);
  //生きている人間だけ処理  
     h.timer ++;  //人間の体内時計を1つカウントアップ
     //人間を描画
     //アニメーションを使っており、体内時計に合わせて動く
     h.draw(); 
     h.drive();
     //if(random(1000) < changeSpeed){h.step += int(random(-1,1));}
     if(h.type == 1){
     h.hp = h.hp - 1; //1単位時間で体力を1減らす
     }
     else if(h.type == 2){
     h.hp = h.hp - 2;}

     if(h.hp < 0){
       h.type = 0;  //もし体力が0になったら、状態を死に変更
       subMAP[h.ycell][h.xcell] = 0;  //状態管理の配列から消去
       Human.remove(j);
       j--;
       Max_Human--;
     }
  if(floor(h.ypos/20)*20+(20-floor(h.xpos/20)) == Length){
    subMAP[h.ycell][h.xcell] = 0;
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
   subMAP[h.ycell][h.xcell] = h.type;
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
  int xcell;
  int ycell;
  int type; //人間の状態
  int direction; //人間の動作方向
  int timer; //体内時計
  int hp; //体力
  int step;
  int seqPosition;
  boolean collide = false;
  int water = 8;
  int stop = 0;
  Human_class(int c, int xp, int yp,  int t, int h, int st, int seq) {
    xpos = xp;
    ypos = yp;
    type = c;
    timer = t;
    hp = h;
    step = st;
    seqPosition = seq;
    if(floor(seq/20)%2 == 0){xpos = (seq%20)*20+1; }
    else{xpos = Length-(seq%20)*20-20-step;}
    ypos = floor(seq/20)*20;//+10;
    xcell = floor(xpos/20);
    ycell = floor(ypos/20);

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
    /*  if(stop != 0){
        collide = false;
        stop -= 1;
        return; 
      }*/

      xcell = floor(xpos / 20);
      ycell = floor(ypos / 20);

      int nextStep = step;
      if(ycell == 10){nextStep = step-1;}// for slow row
      if(ycell == 10 && xpos >= 190 && xpos <= 210 && water > 0){
        if(random(10) <= water){xpos += step;}
        water -= 1;
        return;
      }
      
      int tx = xpos, ty = ypos;
      if(ycell % 2 == 0 || xcell == 0){direction=1;}//right
      else if(ycell % 2 == 1 || xcell == 19){direction=2;}//left
      if((ycell % 2 == 0 && xcell == 19) || (ycell % 2 == 1 && xcell == 0)){direction=3;}//down

      switch(direction){    
      case 1:
          if(xcell != 0 && subMAP[ycell][xcell-1] == 2 && random(5000) < infection){
            setType(2);  
          }
          xpos += nextStep;
          
          if(xcell != floor(xpos/20) && subMAP[ycell][xcell+1] == 0){
            subMAP[ycell][xcell] = 0;
            subMAP[ycell][xcell+1] = type;
          }
          else if(xcell != floor(xpos/20) && subMAP[ycell][xcell+1] != 0){
            if(subMAP[ycell][xcell+1] == 2 && random(1000) < infection){
                setType(2);
              }
            xpos = tx;
            collide = true;
            stop = 2;
        }
          break;
          
      case 2:
          if(xcell != 19 && subMAP[ycell][xcell+1] == 2 && random(5000) < infection){
            setType(2);  
          }
          xpos -= nextStep;
          if(xcell != floor(xpos/20) && subMAP[ycell][xcell-1] == 0){
            subMAP[ycell][xcell] = 0;
            subMAP[ycell][xcell-1] = type;            
          }
          else if(xcell != floor(xpos/20) && subMAP[ycell][xcell-1] != 0){
            if(subMAP[ycell][xcell-1] == 2 && random(1000) < infection){
                setType(2);
              }            
            xpos = tx;
            collide = true;
            stop = 2;
          }
          break;
          
      case 3:
          ypos += nextStep;
            if(ycell != floor(ypos/20) && subMAP[ycell+1][xcell] == 0){
              subMAP[ycell][xcell] = 0;
              subMAP[floor(ypos/20)][xcell] = type;
            }
            else if(ycell != floor(ypos/20) && subMAP[ycell+1][xcell] != 0){
              ypos = ty;
              collide = true;            
              stop = 2;
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
    fill(200,200,200);
    rect(25,20*i,Length-25,2); //<>//
    }
    else{
    rect(0,20*i,Length-25,2);
    }
  }
  fill(100,200,100);
  rect(5,height-5,20,5);
  
  fill(200, 130, 100);
  rect(0, 202, width, 18);
  fill(100, 100, 200);
  rect(190,202, 20, 18);
  
}

void mousePressed() {
 saveFrame("human3.png"); 
}
