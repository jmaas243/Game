----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 06:05:08 PM
-- Design Name: 
-- Module Name: color_scheme - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity color_scheme is
    Port ( 
    Data_In : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    R_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    G_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    B_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end color_scheme;

architecture Behavioral of color_scheme is

begin

process(Data_In)
begin        
        if (Data_In = x"0") then
                R_Data_Out <= x"F";         
                G_Data_Out <= x"F";
                B_Data_Out <= x"F";      
        elsif (Data_In = x"1") then
                R_Data_Out <= x"A";         
                G_Data_Out <= x"A";
                B_Data_Out <= x"A";
        elsif (Data_In = x"2") then       --dark grey
                R_Data_Out <= x"2";         
                G_Data_Out <= x"2";
                B_Data_Out <= x"2";
        elsif (Data_In = x"3") then
                R_Data_Out <= x"0";         
                G_Data_Out <= x"0";
                B_Data_Out <= x"0";
        elsif (Data_In = x"4") then
                R_Data_Out <= x"F";         
                G_Data_Out <= x"F";
                B_Data_Out <= x"5";
        elsif (Data_In = x"5") then
                R_Data_Out <= x"0";         
                G_Data_Out <= x"A";
                B_Data_Out <= x"0";  
        elsif (Data_In = x"6") then
                R_Data_Out <= x"5";         
                G_Data_Out <= x"F";
                B_Data_Out <= x"5";                                         
        elsif (Data_In = x"7") then
                R_Data_Out <= x"F";         
                G_Data_Out <= x"5";
                B_Data_Out <= x"5"; 
        elsif (Data_In = x"8") then
                R_Data_Out <= x"A";         
                G_Data_Out <= x"0";
                B_Data_Out <= x"0";   
        elsif (Data_In = x"9") then
                R_Data_Out <= x"A";         
                G_Data_Out <= x"5";
                B_Data_Out <= x"0";
        elsif (Data_In = x"A") then
                R_Data_Out <= x"A";         
                G_Data_Out <= x"0";
                B_Data_Out <= x"A";   
        elsif (Data_In = x"B") then
                R_Data_Out <= x"F";         
                G_Data_Out <= x"5";
                B_Data_Out <= x"F";   
        elsif (Data_In = x"C") then
                R_Data_Out <= x"5";         
                G_Data_Out <= x"F";
                B_Data_Out <= x"F";   
        elsif (Data_In = x"D") then
                R_Data_Out <= x"0";         
                G_Data_Out <= x"A";
                B_Data_Out <= x"A";  
        elsif (Data_In = x"E") then
                R_Data_Out <= x"0";         
                G_Data_Out <= x"0";
                B_Data_Out <= x"A";                      
        elsif (Data_In = x"F") then
                R_Data_Out <= x"5";         
                G_Data_Out <= x"5";
                B_Data_Out <= x"F";
    end if;
    
end process;       
end Behavioral;
