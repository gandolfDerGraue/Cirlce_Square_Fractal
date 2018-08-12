class Square {
  float x, y;
  float w, h;
  ArrayList<Circle>circles=new ArrayList<Circle>();

  ///////////////////////////////////////////////////
  void show() {
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(x,y,w,h);
    int countStuck=0;
    Circle deleteSmall=new Circle(0,0,0,0,0,0);
    for (Circle c : this.circles) {
      if(c.r<2&&c.stuck==true)deleteSmall=c;
      c.show();
      c.grow(circles);
      if (c.stuck==true)countStuck++;
    }
    circles.remove(deleteSmall);
    if (countStuck==circles.size())spawn();
  }
  ///////////////////////////////////////////////////
  void spawn() {

    float xx=random(x, x+w);
    float yy=random(y, y+h);

    for (Circle c : this.circles) {
      float dis=dist(xx, yy, c.x, c.y);
      if (dis<c.r) {
        spawn();
        return;
      }
    }
    circles.add(new Circle(xx, yy,x,y,x+w,y+h));
  }
  ///////////////////////////////////////////////////
  Square(float x_, float y_, float w_, float h_) {
    x=x_;
    y=y_;
    w=w_;
    h=h_;
  }
  ///////////////////////////////////////////////////
}