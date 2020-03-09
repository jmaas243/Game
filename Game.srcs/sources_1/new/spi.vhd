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

entity SPI is
    Port ( SCK  : in  STD_LOGIC;    -- SPI input clock
           MISO : out STD_LOGIC;    -- SPI serial data output
           MOSI : in  STD_LOGIC;    -- SPI serial data input
           SS   : in  STD_LOGIC;    -- chip select input (active low)
           LED  : out STD_LOGIC_VECTOR (7 downto 0) := x"FF");
end SPI;

architecture Behavioral of SPI is
    signal dat_reg : STD_LOGIC_VECTOR (7 downto 0);
    signal output_reg : STD_LOGIC_VECTOR (7 downto 0);
begin

    process (SCK)
    begin
        if (SCK'event and SCK = '1') then  -- rising edge of SCK
            if (SS = '0') then             -- SPI CS must be selected
                -- shift serial data into dat_reg on each rising edge
                -- of SCK, MSB first
                dat_reg <= dat_reg(6 downto 0) & MOSI;      --input MOSI into dat_reg
                
                MISO <= not dat_reg(7);                     --output dat_reg into MISO
            end if;
        end if;
    end process;

   process (SS)
  begin
        if (SS'event and SS = '1') then
            -- update LEDs with new data on rising edge of CS
            LED <= dat_reg ;
       end if;
   end process;

end Behavioral;
