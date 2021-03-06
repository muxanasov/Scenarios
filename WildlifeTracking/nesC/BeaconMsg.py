#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'BeaconMsg'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 4

# The Active Message type associated with this message.
AM_TYPE = -1

class BeaconMsg(tinyos.message.Message.Message):
    # Create a new BeaconMsg of size 4.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=4):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <BeaconMsg> \n"
        try:
            s += "  [msgtype=0x%x]\n" % (self.get_msgtype())
        except:
            pass
        try:
            s += "  [nodeid=0x%x]\n" % (self.get_nodeid())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: msgtype
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'msgtype' is signed (False).
    #
    def isSigned_msgtype(self):
        return False
    
    #
    # Return whether the field 'msgtype' is an array (False).
    #
    def isArray_msgtype(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'msgtype'
    #
    def offset_msgtype(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'msgtype'
    #
    def offsetBits_msgtype(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'msgtype'
    #
    def get_msgtype(self):
        return self.getUIntElement(self.offsetBits_msgtype(), 16, 1)
    
    #
    # Set the value of the field 'msgtype'
    #
    def set_msgtype(self, value):
        self.setUIntElement(self.offsetBits_msgtype(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'msgtype'
    #
    def size_msgtype(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'msgtype'
    #
    def sizeBits_msgtype(self):
        return 16
    
    #
    # Accessor methods for field: nodeid
    #   Field type: int
    #   Offset (bits): 16
    #   Size (bits): 16
    #

    #
    # Return whether the field 'nodeid' is signed (False).
    #
    def isSigned_nodeid(self):
        return False
    
    #
    # Return whether the field 'nodeid' is an array (False).
    #
    def isArray_nodeid(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'nodeid'
    #
    def offset_nodeid(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'nodeid'
    #
    def offsetBits_nodeid(self):
        return 16
    
    #
    # Return the value (as a int) of the field 'nodeid'
    #
    def get_nodeid(self):
        return self.getUIntElement(self.offsetBits_nodeid(), 16, 1)
    
    #
    # Set the value of the field 'nodeid'
    #
    def set_nodeid(self, value):
        self.setUIntElement(self.offsetBits_nodeid(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'nodeid'
    #
    def size_nodeid(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'nodeid'
    #
    def sizeBits_nodeid(self):
        return 16
    
