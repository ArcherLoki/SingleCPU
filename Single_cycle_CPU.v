`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/08 14:53:06
// Design Name: 
// Module Name: Single_cycle_CPU
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

module Single_cycle_CPU(Clk,Clrn,Inst,Date_out,PC,We,R,Date_in,X,Y);
    input [31:0]Inst,Date_out;
    input Clk,Clrn;
    output We;
    output [31:0]R/*R�����ݴ�������Addr*/,Date_in/*д�����ݴ�������ֵ*/,PC,X,Y;
    
    wire  [31:0] PC_plus4 , Next_PC/*��һPC��ַPC*/, address/*����PC������ֵ�ĵڶ���*/,Qa,Qb,Alu_a/*ALU������a*/, Alu_b/*ALU������b*/,D;
    wire  [1:0] Aluc;
    wire  [4:0] Wr;
    wire  [1:0] Pcsrc;
    wire  Z, Wmem, Wreg, Regrt, Reg2reg, Aluqb, Se;//����Control_unit����
    wire [15:0]immediate = {Inst[15:0]};//������
    wire [31:0]ExtL_immediate;//��չ��λ������
    wire [31:0] Ext_immediate;//��չ������
    Extend EX1(Inst[15:0],Se,Ext_immediate);//��������������չ
    SHIFTER_32 Shifter_imm0(Ext_immediate,5'b00010,1'b1,1'b0,ExtL_immediate);//��������������λ
    controlUnit ctrl1(Inst[31:26] , Inst[5:0] ,Z, Regrt, Se , Wreg ,Aluqb, Aluc, Wmem ,Pcsrc, Reg2reg);//�жϿ���ֵ
    assign We = Wmem;//��We���ݴ������źŸ�ֵ
    MUX2X5 Reg_Wr(Inst[15:11],Inst[20:16],Regrt,Wr);//Inst��Wr��rt��rd��ѡ��
    MUX2X32 ALU2(Qb,Ext_immediate,Aluqb,Alu_b);//ѡ�񲢸�Y��ֵ
    assign Alu_a = Qa;//��X��ֵ
    ALU Alu0(Alu_a,Alu_b,Aluc,R,Z);//ALU����
    MUX2X32 Result0(Date_out,R,Reg2reg,D);//�ﵽ���ݴ�������Rѡ�������D
    Regfilee Regfile0(Inst[25:21],Inst[20:16],D,Wr,Wreg,Clk,Clrn,Qa,Qb);
    Dff_32 PC0(Next_PC,Clk,Clrn,PC);//PC�Ĵ�������
    CLA32 PC_plus(PC,32'h4,1'b0,PC_plus4);//PC+4����
    CLA32 Addr1(PC_plus4,ExtL_immediate,1'b0,address);//��������λ+PC_plus4��ֵ����Ϊ��һPC��ַѡ������A2�ӿ�
    wire [31:0]J_PC = {PC_plus4[31:28],Inst[25:0],2'b00};//J��ָ����ת
    MUX4X32_D NextPC(PC_plus4,32'h00000000,address,J_PC,Pcsrc,Next_PC);//��һPC��ַ��ѡ��
    assign Date_in = Qb;//��Date_in��ֵ
    assign X=Alu_a;
    assign Y=Alu_b;
endmodule
