`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/11 02:51:18
// Design Name: 
// Module Name: All_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module All_contorl(Clk,Clrn,Inst,Date_out,PC,R,X,Y);
    input Clk,Clrn;
    output [31:0]Inst,Date_out;//�����ݴ�������ȡ������
    output [31:0]PC/*PC��ַ*/,R/*Alu������*/;
    output [31:0]X,Y;
    wire We;
    wire [31:0]Date_in;//��Ҫд�����ݴ洢��������
    
    Single_cycle_CPU C1(Clk,Clrn,Inst,Date_out,PC,We,R,Date_in,X,Y);
    DATAMEM dmem(R,Date_in,Clk,We,Date_out);
    INSTMEM imem(PC,Inst);
endmodule

