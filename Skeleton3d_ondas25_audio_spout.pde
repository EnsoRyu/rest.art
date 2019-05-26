//libreria para enviar a resolume
import spout.*;
Spout spout;
//kinect libreria
import KinectPV2.KJoint;
import KinectPV2.*;
KinectPV2 kinect;
//OSC libreria
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

int i = 0;
int a = 0;

//ONDA
float[] xmap = new float[3];
float[] ymap = new float[3];
float[] zmap = new float[3];


//AÑADIDO
float xjoint, yjoint, zjoint;
float xMapped, yMapped, zMapped;
float xobject = 0;
float yobject = 0;
float zobject = 0;

float xmin = -1.44;
float xmax = 1.44;
float ymin = 0;
float ymax = 0;
float zmin = 1.4;
float zmax = 3;

int ncuerpo;
int dtxt = 80;

IntList personas;

boolean istracked;
//__________________________________

ArrayList<gusanito> gusanitos = new ArrayList<gusanito>();
int c = 7;
float[] realtam = new float[c];//{8,8,6,17,5,6,50,1,30,2,8,8,6,17,5,6,50,1,30,2}; //tamaño de cada gusanito
int tammin = 1, tammax = 35;
float[] tam = new float[c]; //tamaño inicial, sino aparecen de golpe, poco a poco van creciendo en la salida.
int x = -35;
int[] yposition = {x, x*2, x*4, x*7,-x*2,-x*4,-x*7};//{-x*140,-x*120,-x*100,-x*80,-x*60,-x*40,-x*20,-x,x*140,x*120,x*100,x*80,x*60,x*40,x*20,x}; //posicion de la onda donde circularán
int[] stroke = new int[c]; // tamaño de cada onda
int [] time = new int[c];//{2000,20,1000,4,0,300,60,120,10,80,2000,20,1000,4,0,300,60,120,10,80}; //tiempo de salida de cada gusanito
IntList timer; //contador de salida
float strokemin, strokemax;
int f = 2;
float strokemin1 = 4/f, strokemin2 = 40/f, strokemax1 = 140/f, strokemax2 = 50/f; 

//float periode;
//float stroke;
color cf, cb;
color c1 = color(115, 192, 166);
color c2 = color(77, 86, 159);
color c3 = color(243,236,132);
color c4 = color(246,167,109);

float mapperiod;
//----------------------
boolean start = false;
boolean onetime = true;
boolean voz1 = false;
boolean voz2 = false;
boolean voz3 = false;
boolean eco = false;
boolean cstart, cvoz1, cvoz2, cvoz3, ceco;

void setup() {
  frameRate(40);
  colorMode(RGB);
  smooth(0);
  textSize(50);
  size(1024, 768, P2D);
  //spout setup
  textureMode(NORMAL);
  spout = new Spout(this);
  spout.createSender("Spout Processing");
  //osc setup
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,8000);
  myRemoteLocation = new NetAddress("127.0.0.1",8000);
  //
  kinect = new KinectPV2(this);
  //kinect.enableColorImg(true);
  //enable 3d  with (x,y,z) position
  kinect.enableSkeleton3DMap(true);
  kinect.init();
//_____________________
  gusanitos = new ArrayList<gusanito>();
  timer = new IntList();
  maptamano();
  mapperiod();
  for (int a =0; a <c; a++) {
  //yposition[a]= int(random(-100,100));
  stroke[a] = int(random(strokemin,strokemax));
  realtam[a] = random(tammin,tammax);
  tam[a] = 0;
  gusanitos.add(new gusanito(yposition[a],tam[a]));
  time[a] = int(random(0,700));
  timer.append(time[a]);
  }
  //translate(0,-1000);
  
  cstart = false;
  cvoz1 = false;
  cvoz2 = false;
  cvoz3 = false;
  ceco = false;
}

void draw() {
background(0);
  //image(kinect.getColorImage(), 0, 0, width, height);
start = false;
voz1 = false;
voz2 = false;
voz3 = false;
eco = true;
istracked = false;


  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
  for (i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      istracked = true;
      start = true;
      eco = false;
      KJoint[] joints = skeleton.getJoints();
      //recoge las posiciones XYZ
      posicion(joints);
      //println(i);
      if (i == 0){
      //mappea los valores de Z en colores;
      voz1 = true;
      voz2 = true;
      voz3 = true;
      mapgradient();
      //maptamano();
      //mapperiod();
      //descuento por cada contador de gusanito
      for (int i = 0; i < timer.size(); i++) {
                  int time = timer.get(i);
                  time--;
                  timer.set(i, time);
                }
      for (int i = 0; i < gusanitos.size(); i++) {
        //si es el contador llegá a cero se ejecuta gusanito
        if (timer.get(i) <= 0){
          gusanito p = gusanitos.get(i);
          p.calcWave(yposition[i], mapperiod);
          p.renderWave(tam[i], stroke[i],cf,cb);
          //evita que se desplace mientras crece
          if (realtam[i] < tam[i]) {
          p.progress(tam[i]);
          }
          //si el gusanito llega a su final, el contador, el tamaño, grosor y la position se reinician.
          if(p.end == true){ 
              timer.set(i, int(random(0,500)));
              realtam[i] = random(tammin,tammax);
              tam[i]=0;
              //yposition[i]= int(random(-100,100));
              stroke[i] = int(random(strokemin,strokemax));
          }
          p.returned(tam[i]);
          //crecimiento inicial de gusanito
          if (realtam[i] > tam[i]) {
            tam[i] = tam[i] + 1;
          }
        }
      }
      }
      if (i == 1){
      println("persona2");
      //mappea los valores de X en periodo;
      mapperiod();
      //voz2 = true;
      }
      if (i == 2){
      println("persona3");
      //mappea los valores de X en periodo;
      maptamano();
      //voz3 = true;
      }
      
      
          
    }
  }
  if (istracked == false){
  //println("giliiiii");
  for (int i = 0; i < gusanitos.size(); i++) {
  gusanito p = gusanitos.get(i);
  timer.set(i, int(random(0,500)));
  realtam[i] = random(tammin,tammax);
  tam[i]=0;
  //yposition[i]= int(random(-100,100));
  stroke[i] = int(random(strokemin,strokemax));
  p.newstart();
  }
}
//OSC send
oscsenderstart();
  
//TEXTO informativo
//background(255);
 /* fill(255,100,100);
  text(frameRate, 50, dtxt);
  text(skeletonArray.size(), 50, dtxt*2);
  text (cb+" cb  ", 50, dtxt*3);
  text (cf+" cf ", 50, dtxt*4);
  text (mapperiod+" mapperiod  ", 50, dtxt*5);
   text (strokemin+" strokemin ", 50, dtxt*6);
  text (strokemax+" strokemax  ", 50, dtxt*7);*/
  
//SPOUT send
  
  spout.sendTexture();
}

//localización
void posicion(KJoint[] joints) {
  ncuerpo = KinectPV2.JointType_Head;
  xjoint = joints [ncuerpo].getX();
  yjoint = joints [ncuerpo].getY();
  zjoint = joints [ncuerpo].getZ();
  //println(xjoint, yjoint, zjoint);  
}

void mapgradient() {
float maplerp = map(xjoint, xmin, xmax, 0, 1);
cf = lerpColor(c1,c3, maplerp);
cb = lerpColor(c2,c4, maplerp);
}

void mapperiod(){
mapperiod = map(xjoint, xmin, xmax, 5, 100);
}

void maptamano(){
strokemin = map(xjoint, xmin, xmax, strokemin1, strokemin2);
strokemax = map(xjoint, xmin, xmax, strokemax1, strokemax2);
}

//OSC function
void oscsenderstart(){
    /* create an osc bundle */
  OscBundle myBundle = new OscBundle();
  OscMessage myMessage = new OscMessage("/hola");
  if ((cstart != start) && (onetime == true)){
  onetime = false;
  myMessage.clear();
  /* createa new osc message object */
  myMessage.setAddrPattern("/start");
  myMessage.add(start);
  myBundle.add(myMessage);
  cstart = start;
  println("enviado start");
  }
  
  if (cvoz1 != voz1){
  myMessage.clear();
  myMessage.setAddrPattern("/voz1");
  myMessage.add(voz1);
  myBundle.add(myMessage);
  cvoz1 = voz1;
  }
  if (cvoz2 != voz2){
  myMessage.clear();
  myMessage.setAddrPattern("/voz2");
  myMessage.add(voz2);
  myBundle.add(myMessage);
  cvoz2 = voz2;
  }
  if (cvoz3 != voz3){
  myMessage.clear();
  myMessage.setAddrPattern("/voz3");
  myMessage.add(voz3);
  myBundle.add(myMessage);
  cvoz3 = voz3;
  }
  if (ceco != eco){
  myMessage.clear();
  myMessage.setAddrPattern("/eco");
  myMessage.add(eco);
  myBundle.add(myMessage);
  ceco = eco;
  }
  myBundle.setTimetag(myBundle.now() + 10000);
  /* send the osc bundle, containing 2 osc messages, to a remote location. */
  oscP5.send(myBundle, myRemoteLocation);
}