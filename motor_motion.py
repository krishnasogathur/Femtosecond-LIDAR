import serial

direction = "left"
#Directions are given from the perspective facing HOLMARC sign in FSLab
def send_command(ser,command):
    ser.write(command.encode())

def right_step(ser,dist,speed):
    send_command(ser,f'R{dist} {speed}')
    print(ser.readline())

def left_step(ser,dist,speed):
    send_command(ser,f'E{dist} {speed}')
    print(ser.readline())

def y_step(ser,dist, speed):
    dist*=6400
    speed*=6400
    if direction.lower() == "left":
        left_step(ser,dist,speed)
    elif direction.lower() == "right":
        right_step(ser,dist,speed)
    else:
        exit()


def home_set(ser,):
    send_command(ser,'X')
    print(ser.readline())


def down_step(ser,dist,speed):
    send_command(ser,f'D{dist} {speed}')
    print(ser.readline())


def up_step(ser,dist,speed):
    send_command(ser,f'U{dist} {speed}')
    print(ser.readline())


def home_step(ser):
    send_command(ser,'H')  
    print(ser.readline())
    print(ser.readline())
    print(ser.readline())

def getlocation(ser):
    send_command(ser,'L')
    t =  int(ser.readline().split()[-1]), int(ser.readline().split()[-1])
    print(t)
    return t