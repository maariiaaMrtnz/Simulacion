abstract class Wave{
  protected PVector tmp;
  
  protected float A, C, W, Q, phi;
  protected PVector D;
  
 public Wave(float _a, PVector _srcDir, float _L, float _C){
    
    //Declaración de parámetros de onda
    tmp = new PVector();
    C = _C; //Velocidad de propagación
    A = _a; //Amplitud
    D = new PVector().add(_srcDir); //Centro (radial) o dirección de onda
    W = PI * 2f / _L; //Velocidad de onda 
    Q = PI*A*W; //Factor Q de las Ondas de Gerstner
    
    phi = C*W; //Fase de onda
  
  }
  
  abstract PVector getVariation(float x, float y, float z, float time);
}  
  
//ONDA DIRECCIONAL
  
class WaveDirectional extends Wave{
  public WaveDirectional(float _a, PVector _srcDir, float _L, float _C){
    super(_a, _srcDir, _L, _C);
    //_srcDir representa la dirección de las ondas --> se debe normalizar
    D.normalize();
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    tmp.x = 0;
    tmp.z = 0;
    tmp.y = A * sin((D.x*x +D.z*z)*W + time*phi); //Obtención de la variación de onda mediante la distancia y ecuación de onda direccional
    return tmp;
  }

}
  
//ONDA RADIAL
  
class WaveRadial extends Wave{
  public WaveRadial(float _a, PVector _srcDir, float _L, float _C){
    super(_a, _srcDir, _L, _C);
    //_srcDir en este caso es el epicentro de la perturbación
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    tmp.x = 0;
    tmp.z = 0;
    
    float dist = (sqrt((x-D.x)*(x-D.x) + (z-D.z)*(z - D.z)));
    tmp.y = A * sin(W*dist - time*phi); //Obtención de la variación de onda mediante la distancia y ecuación de onda radial
    
    return tmp;
  }

}
  
 
//ONDA DE GERSTNER 
  
class WaveGerstner extends Wave{
  public WaveGerstner(float _a, PVector _srcDir, float _L, float _C){
    super(_a, _srcDir, _L, _C);
    D.normalize(); //Debemos normalizar _srcDir porque representa una dirección en las ondas de Gerstner
  }
  public PVector getVariation(float x, float y, float z, float time){
    
    //Obtención de la variación de onda mediante la distancia y ecuación de onda de Gerstner
    tmp.x = Q * A * D.x * cos(W*(D.x*x + D.z*z) + time*phi);
    tmp.z = Q * A * D.z * cos(W*(D.x*x + D.z*z) + time*phi);
    tmp.y = -A * sin(W*(D.x*x + D.z*z) + time*phi);    
    
    return tmp;
  }

}
