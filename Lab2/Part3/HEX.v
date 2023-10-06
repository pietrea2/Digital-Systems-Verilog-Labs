`timescale 1ns/1ns

module HEX( SW, HEX0 );

input [3:0] SW;
output [6:0] HEX0;

h0 U1( .p0(SW[0]), .p1(SW[1]), .p2(SW[2]), .p3(SW[3]), .p4(HEX0[0]) );
h1 U2( .p0(SW[0]), .p1(SW[1]), .p2(SW[2]), .p3(SW[3]), .p4(HEX0[1]) );
h2 U3( .p0(SW[0]), .p1(SW[1]), .p2(SW[2]), .p3(SW[3]), .p4(HEX0[2]) );
h3 U4( .p0(SW[0]), .p1(SW[1]), .p2(SW[2]), .p3(SW[3]), .p4(HEX0[3]) );
h4 U5( .p0(SW[0]), .p1(SW[1]), .p2(SW[2]), .p3(SW[3]), .p4(HEX0[4]) );
h5 U6( .p0(SW[0]), .p1(SW[1]), .p2(SW[2]), .p3(SW[3]), .p4(HEX0[5]) );	
h6 U7( .p0(SW[0]), .p1(SW[1]), .p2(SW[2]), .p3(SW[3]), .p4(HEX0[6]) );

endmodule 



//logic for all 7 segments
module h0 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( p0|p1|(~p2)|p3 )&( (~p0)|(~p1)|p2|(~p3) )&( (~p0)|p1|(~p2)|(~p3) ) );

endmodule 

module h1 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|(~p2)|p3 )&( p0|(~p1)|(~p2)|p3 )&( (~p0)|(~p1)|p2|(~p3) )&( p0|p1|(~p2)|(~p3) )&( p0|(~p1)|(~p2)|(~p3) )&( (~p0)|(~p1)|(~p2)|(~p3) ) );

endmodule 

module h2 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( p0|(~p1)|p2|p3 )&( p0|p1|(~p2)|(~p3) )&( p0|(~p1)|(~p2)|(~p3) )&( (~p0)|(~p1)|(~p2)|(~p3) ) );

endmodule 

module h3 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( p0|p1|(~p2)|p3 )&( (~p0)|(~p1)|(~p2)|p3 )&( (~p0)|p1|p2|(~p3) )&( p0|(~p1)|p2|(~p3) )&( (~p0)|(~p1)|(~p2)|(~p3) ) );

endmodule 

module h4 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( (~p0)|(~p1)|p2|p3 )&( p0|p1|(~p2)|p3 )&( (~p0)|p1|(~p2)|p3 )&( (~p0)|(~p1)|(~p2)|p3 )&( (~p0)|p1|p2|(~p3) ) );

endmodule 

module h5 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( (~p0)|p1|p2|p3 )&( p0|(~p1)|p2|p3 )&( (~p0)|(~p1)|p2|p3 )&( (~p0)|(~p1)|(~p2)|p3)&( (~p0)|p1|(~p2)|(~p3) ) );

endmodule 

module h6 (input p0, p1, p2, p3, output p4);

assign p4 = ~( ( p0|p1|p2|p3 )&( (~p0)|p1|p2|p3 )&( (~p0)|(~p1)|(~p2)|p3 )&( p0|p1|(~p2)|(~p3) ) );

endmodule 