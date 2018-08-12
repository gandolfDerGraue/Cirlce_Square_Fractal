class Circle {
  float x, y, r;
  color c;
  float boundW, boundH, boundWW, boundHH;
  boolean stuck=false;
  boolean growing=true;
  float tau=2*PI;
  float pastR=0;
  float traveledDis=0;
  ArrayList<Float> bounds = new ArrayList<Float>();
  Square s;

  ///////////////////////////////////////////////
  void show() {
    ellipseMode(CENTER);
    stroke(0);
    ncolor();
    fill(c);
    ellipse(x, y, r*2, r*2);
    if(s!=null)s.show();
    
  }
  ///////////////////////////////////////////////
  void isStuck() {
    if (bounds.size()>2) {
      stuck=true;
      if(s==null&&r>15)s=new Square(x-r*0.707106, y-r*0.707106, r*2*0.707106, r*2*0.707106);
    }
  }
  ///////////////////////////////////////////////
  void ncolor() {

    float green=map(log(r), 0, log(boundWW-boundW), 1, 0);
    c=color(0, green*255, 0);
    //c=color(255);
  }

  ///////////////////////////////////////////////
  void move() {
    isStuck();
    if (!stuck) {
      PVector direction=new PVector(0, 0);
      for (Float a : bounds) {
        direction.add(new PVector(cos(a), sin(a)));
      }
      direction=direction.setMag(.5);
      x=x-direction.x;
      y=y-direction.y;

      if (pastR==r) {
        traveledDis+=direction.mag();
      } else traveledDis=0.0;
      float length=boundHH-boundH;
      if (traveledDis>length/2) {
        stuck=true;
        if(s==null&&r>15)s=new Square(x-r*0.707106, y-r*0.707106, r*2*0.707106, r*2*0.707106);
        c=color(255, 0, 0);
      }
      bounds.clear();
      pastR=r;
    }
  }
  ///////////////////////////////////////////////
  boolean same(float f) {
    for (float other : bounds) {
      if (abs(f-other)<0.1)return true;
    }
    return false;
  }
  ///////////////////////////////////////////////
  void touch(ArrayList<Circle> circles) {
    if (x+r>boundWW) {
      if (!same(0.0))bounds.add(0.0);
    }
    if (y+r>boundHH) {
      if (!same(PI/2))bounds.add(PI/2);
    }  
    if (x-r<boundW) {
      if (!same(PI))bounds.add(PI);
    }
    if (y- r<boundH) {
      if (!same(PI*3/2))bounds.add(PI*3/2);
    }
    for (Circle other : circles) {
      if (other!=this) {
        float dis=dist(x, y, other.x, other.y);
        if (dis< r+other.r) {//oder auch dis<r+other.r+1
          PVector v1=new PVector(1, 0);
          PVector v2=new PVector(other.x-x, other.y-y);
          float angle =PVector.angleBetween(v1, v2);
          if (other.y-y<0)angle=2*PI-angle;
          if (!same(angle))bounds.add(angle);
        }
      }
    }
    if (bounds.size()>0) {
      move();
      growing=false;
    } else growing=true;
  }
  ///////////////////////////////////////////////
  void grow(ArrayList<Circle> circles) {
    touch(circles);
    if (!stuck&&growing)r+=0.5;
  }
  ///////////////////////////////////////////////
  Circle(float x_, float y_, float boundW, float boundH, float boundWW, float boundHH) {
    x=x_;
    y=y_;
    r=0.001;
    this.boundW=boundW;
    this.boundH=boundH;
    this.boundWW=boundWW;
    this.boundHH=boundHH;
  }
  ///////////////////////////////////////////////
}