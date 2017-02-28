import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web
import socket

import serial
'''
This is a simple Websocket Echo server that uses the Tornado websocket handler.
''' 
serialPort = serial.Serial(
    port='/dev/ttyUSB0',\
    baudrate=9600,\
    parity=serial.PARITY_NONE,\
    stopbits=serial.STOPBITS_ONE,\
    bytesize=serial.EIGHTBITS,\
        timeout=0)
 
class WSHandler(tornado.websocket.WebSocketHandler):
    def open(self):
        print ('new connection')
        tornado.ioloop.PeriodicCallback(self.readSerial, 75).start()
      
    def on_message(self, message):
        print ('message received:  %s' % message)
    	serialPort.write(message.encode())
 
    def on_close(self):
        print ('connection closed')
 
    def check_origin(self, origin):
        return True

    def readSerial(self):
        size = serialPort.inWaiting()
        if (size):
           print '{0}->  {1}'.format(size, serialPort.readline())
 
application = tornado.web.Application([
    (r'/ws', WSHandler),
])

 
if __name__ == "__main__":
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(8888)
    myIP = socket.gethostbyname(socket.gethostname())
    print ('*** Websocket Server Started at %s***' % myIP)
    tornado.ioloop.IOLoop.instance().start()
