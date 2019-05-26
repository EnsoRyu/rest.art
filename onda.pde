class gusanito{
int xspacing = 3;   // separación entre cada punto creado en la sinuidal. También podria verse como la calidad de la onda.
int w;              // Tamaño entero del recorrido de la onda

float theta = 0.0;  // Ángulo inicial de la onda
float amplitude = 75.0;  // Ancho de la onda
float period = 500.0;  // Cuantos pixeles antes de repetirse la onda
float dx;  // valor de incremento de x, representa la función de la onda.
float[] yvalues;  // Array para situar en posicion y cada punto de la onda. 

//Colores del gradiente de la onda
float H;
float S;
float B;

//tamaño del gusanito
float vstroke = 0;

//constante de variación de los puntos de la y, tiene el proposito de mover toda la onda en la posición y
int yposition;

float tam; // tamaño final del gusanito
boolean end = false; //indica si llego al final.

gusanito(int ypositions, float tams){
  strokeCap(SQUARE);
  w = width+35;
  //calculo del sinuoide 
  yvalues = new float[w/xspacing];
  yposition = ypositions;
  tam = tams;
  
}

//cálculo de la onda completa
void calcWave(int yposition, float amplitude) {
  // Increment theta (try different values for 'angular velocity' here
  //theta += 0.02;
    dx = (TWO_PI / period) * xspacing;
  // Por cada valor de x, calcula el valor de y de la onda.
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = (sin(x)*amplitude)+yposition;
    x+=dx;
  }
}

//render completo de la onda
void renderWave(float tam, float stroke, color c1, color c2 ) {

  strokeWeight(stroke);
  strokeCap(ROUND);
  //esta formula pinta una parte de la onda, creando este efecto de gusanitos siguiendo un recorrido.
  for (int x = 1; x < yvalues.length; x++) {
    float inter = map(x,1,yvalues.length,0,1);
    color c = lerpColor(c1,c2, inter);
    stroke(c);  
    if (abs(x-vstroke) > tam) {
    noStroke();
    }
    line((x-1)*xspacing, height/2+yvalues[x-1], x*xspacing, height/2+yvalues[x]);
    
  }
}

void progress(float tam){
  vstroke = vstroke+ 1;
  if (vstroke > (yvalues.length+tam)) {
  end = true;
   }
}

void returned(float tam){
     if (vstroke > (yvalues.length+tam)) {
  vstroke = 0; 
  end = false;
}   
  }
  
void newstart() {
vstroke = 0;
end = false;
}

boolean end(){
   return end;
 }



}