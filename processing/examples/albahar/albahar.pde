#lang processing
backend(rhino);

float width = 2*PI;
float height = 30;
int n = 26;
int m = 20;
float r = 5; //radius pattern screen
float rInt = 0.95*r; //radius glass screen
float fm = 0.5;



float[] ws = division(0,width/n/2,1);
float[] hs = division(0,height/m/2,1);
for(int k = 0; k < ws.length; k++){
//outer screen
 float[] us = division(ws[k],width+ws[k],n); 
 float[] vs = division(hs[k],height+hs[k],m);
 Object[] matrix = new Object[us.length];
 for(int i = 0; i < us.length; i=i+1) {
   Object[] row = new Object[vs.length];
   matrix[i] = row;
   for(int j = 0; j < vs.length; j++) {
     float u = us[i];
     float v = vs[j];
     row[j] = xyz(cos(u)*(r+sin(v*(PI/height))),
                  sin(u)*(r+sin(v*(PI/height))),
                  v);
     }
 }

 Object hexag;
 hexag = emptyShape();
 for(int i = 0; i < matrix.length-1; i++) {
   Object[] row0;
   Object[] row1;
   row0 = matrix[i];
   row1 = matrix[i+1];
   for(int j = 0; j < row0.length-1; j++) {
     Object[] p0,p1,p2,p3;
     p0 = row0[j];
     p1 = row1[j];
     p2 = row1[j+1];
     p3 = row0[j+1];
     float f = max(abs(cos(i*0.1)),0.07);
     Object c = quadCenter(p0,p1,p2,p3);
     Object nn = quadNormal(p0,p1,p2,p3);
     Object p01 = intermediatePoint(p0,p1,fm);
     Object p03 = intermediatePoint(p0,p3,fm);
     Object p12 = intermediatePoint(p1,p2,fm);
     Object pp = addC(intermediatePoint(c,p01,fm),mulC(nn,0.1));
     Object pp0 = intermediatePoint(p03,p01,fm);
     Object pp1 = intermediatePoint(p01,p12,fm);
     Object pt1 = intermediatePoint(pp,pp0,f);
    Object pt2 = intermediatePoint(pp,pp1,f);
    Object pt3 = intermediatePoint(pp,c,f);
    Object triang1 = surface(line(p03,pt1,p01,pp,p03));
    Object triang2 = surface(line(p01,pt2,p12,pp,p01));
    Object triang3 = surface(line(p12,pt3,p03,pp,p12));
    Object triangulo2 = union(triang1,triang2,triang3); 
    //triangulo cima
    Object p32 = intermediatePoint(p3,p2,fm);
    Object ppp = addC(intermediatePoint(c,p32,fm),mulC(nn,0.1));
    Object pp2 = intermediatePoint(p12,p32,fm);
    Object pp3 = intermediatePoint(p03,p32,fm);
    Object pt4 = intermediatePoint(ppp,pp2,f);
    Object pt5 = intermediatePoint(ppp,pp3,f);
    Object pt6 = intermediatePoint(ppp,c,f);
    Object triang4 = surface(line(p03,pt5,p32,ppp,p03));
    Object triang5 = surface(line(p32,pt4,p12,ppp,p32));
    Object triang6 = surface(line(p03,pt6,p12,ppp,p03));
    Object triangulo1 = union(triang4,triang5,triang6);  
    hexag = union(hexag,triangulo2,triangulo1);
   }
 }
}


//Malha do Vidro
float[] uss = division(0,width,20);
float[] vss = division(0,height,m);
Object[] matrixInt = new Object[uss.length];
for(int i = 0; i < uss.length; i=i+1) {
  Object[] row = new Object[vss.length];
  matrixInt[i] = row;
  for(int j = 0; j < vss.length; j++) {
    float u = uss[i];
    float v = vss[j];
    row[j]=xyz(cos(u)*(rInt+sin(v*(PI/height))),
               sin(u)*(rInt+sin(v*(PI/height))),
               v);
    }
}

surfaceGrid(matrixInt);
cylinder(xyz(0,0,height),rInt+sin(height*(PI/height)),0.3);
Object tubes;
tubes = emptyShape();

for(int i = 0; i < matrixInt.length-1; i++) {
  Object[] row0;
  Object[] row1;
  row0 = matrixInt[i];
  row1 = matrixInt[i+1];
  for(int j = 0; j < row0.length-1; j++) {
    Object[] p0,p1,p2,p3;
    p0 = row0[j];
    p1 = row1[j];
    p2 = row1[j+1];
    p3 = row0[j+1];
    tubes = union(tubes,cylinder(p0,(r-rInt)/3,p3));
  }
}
