import struct
import shutil


def load_stl(file):
    ##BINARY STLS, little-endian
    ##UINT8[80]    – Header                 -     80 bytes
    ##UINT32       – Number of triangles    -      4 bytes
    ##
    ##foreach triangle                      - 50 bytes:
    ##    REAL32[3] – Normal vector             - 12 bytes
    ##    REAL32[3] – Vertex 1                  - 12 bytes
    ##    REAL32[3] – Vertex 2                  - 12 bytes
    ##    REAL32[3] – Vertex 3                  - 12 bytes
    ##    UINT16    – Attribute byte count      -  2 bytes
    ##end
    ##vertices are listed in counter-clock-wise order from outside
    
    with open(file, 'rb') as f:
        f.seek(80,0) # don't care about the header,seek from start of file
        #little-endian, use: <
        # I -> unsigned int
        # f -> float32
        num_tri = struct.unpack("<I",f.read(4))[0]

##        normal  = np.zeros((num_tri,3),dtype=np.float32)
##        vertex1 = np.zeros((num_tri,3),dtype=np.float32)
##        vertex2 = np.zeros((num_tri,3),dtype=np.float32)
##        vertex3 = np.zeros((num_tri,3),dtype=np.float32)
##
##        for i in range(num_tri):
##            data = struct.unpack("<ffffffffffff",f.read(4*12))
##            f.seek(2,1) # skip attribute byte count (2 bytes),seek from current location
##
##            for j in range(3):
##                normal[i,j]  = data[j]
##                vertex1[i,j] = data[j+3]
##                vertex2[i,j] = data[j+6]
##                vertex3[i,j] = data[j+9]

    return num_tri



num_features = 651

with open("sculpt_parallel.diatom",'w') as f:
    f.write('diatoms')
    f.write('''
  package 'crack'
    material 10000
    insert stl
      FILE = 'sculpt_stls/crack.stl'
    endinsert
  endpackage
  package 'crack_tip'
    material 20000
    insert stl
      FILE = 'sculpt_stls/crack_tip.stl'
    endinsert
  endpackage\n''')

    for i in range(num_features):
        # sculpt doesn't like empty stls. replace with dummy stl
        if (load_stl('sculpt_stls/Feature_%d.stl'%(i))==0):
            print('Feature_%d.stl is an empty stl. replaced'%i)
            shutil.copy('dummy_stl.stl','sculpt_stls/Feature_%d.stl'%i)
        
        f.write("  package 'volume_%d'\n"%(i))
        f.write("    material %d\n"%(i+1))
        f.write("    insert stl\n      FILE = 'sculpt_stls/Feature_%d.stl'\n    endinsert\n"%(i))
        f.write("  endpackage\n")
        
    f.write("enddiatom")
