----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2020 06:38:45 PM
-- Design Name: 
-- Module Name: SPI - Behavioral
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
use ieee.numeric_std.all; 

package pkg is
  Type RamType is array(9 downto 0) of std_logic_vector(9 downto 0);
end package;

package body pkg is
end package body;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
library work;
use work.pkg.all;

entity SPI is
    Port ( SCK  : in  STD_LOGIC;    -- SPI input clock
           MISO : out STD_LOGIC;    -- SPI serial data output
           MOSI : in  STD_LOGIC;    -- SPI serial data input
           SS   : in  STD_LOGIC;    -- chip select input (active low)
           LED  : out STD_LOGIC_VECTOR (15 downto 0) := x"FFFF";
           Ram  : out RamType
          );
end SPI;

architecture Behavioral of SPI is
    signal dat_reg : STD_LOGIC_VECTOR (15 downto 0);
    signal output_reg : STD_LOGIC_VECTOR (7 downto 0);
    signal werk : STD_LOGIC_VECTOR(3 downto 0);
begin

    process (SCK)
    begin
        if (SCK'event and SCK = '1') then  -- rising edge of SCK
            if (SS = '0') then             -- SPI CS must be selected
                -- shift serial data into dat_reg on each rising edge
                -- of SCK, MSB first
                dat_reg <= dat_reg(14 downto 0) & MOSI;      --input MOSI into dat_reg
                
              --  MISO <= not dat_reg(15);                     --output dat_reg into MISO
            end if;
        end if;
    end process;

--   process (SS)
--  begin
--        if (SS'event and SS = '1') then
--            LED <= dat_reg ;
           
--            Ram(to_integer(unsigned(dat_reg(15 downto 10)))) <= dat_reg(9 downto 0);--"0000000001100100"; --dat_reg;--std_logic_vector(to_unsigned(100, Ram(0)'length));
--       end if;
--   end process;

LED <= dat_reg ;
           
 Ram(to_integer(unsigned(dat_reg(15 downto 10)))) <= dat_reg(9 downto 0);

end Behavioral;
