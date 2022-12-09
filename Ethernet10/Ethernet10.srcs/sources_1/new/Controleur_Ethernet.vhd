----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2022 17:19:03
-- Design Name: 
-- Module Name: Controleur_Ethernet - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Controleur_Ethernet is
    
    Port ( CLK10I : in STD_LOGIC;
           RESETN : in STD_LOGIC;
           
           TABORTP : in STD_LOGIC;
           TAVAILP : in STD_LOGIC;
           TDATAI : in STD_LOGIC_VECTOR (7 downto 0);
           TDATAO : out STD_LOGIC_VECTOR (7 downto 0);
           TDONEP : out STD_LOGIC;
           TFINISHP : in STD_LOGIC;
           TLASTP : in STD_LOGIC;
           TREADDP : out STD_LOGIC;
           TRNSMTP : out STD_LOGIC;
           TSTARTP : out STD_LOGIC;
           TSOCOLP  :   out STD_LOGIC;
           RBYTEP   :   out STD_LOGIC;
           RCLEANP  :   out STD_LOGIC;
           RCVNGP   :   out STD_LOGIC;
           RDATAO   :   out STD_LOGIC_VECTOR (7 downto 0);
           RDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
           RDONEP   :   out STD_LOGIC;
           RENABP   :   in  STD_LOGIC;
           RSTARTP  :   out STD_LOGIC;
           RSMATIP  :   out STD_LOGIC);

end Controleur_Ethernet;

architecture struct of Controleur_Ethernet is
    
    component Recepteur
        port (CLK      :   in  STD_LOGIC;
              RESET    :   in  STD_LOGIC;
              RBYTEP   :   out STD_LOGIC;
              RCLEANP  :   out STD_LOGIC;
              RCVNGP   :   out STD_LOGIC;
              RDATAO   :   out STD_LOGIC_VECTOR (7 downto 0);
              RDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
              RDONEP   :   out STD_LOGIC;
              RENABP   :   in  STD_LOGIC;
              RSTARTP  :   out STD_LOGIC;
              RSMATIP  :   out STD_LOGIC);
    end component;
    
    component Emetteur
        port (CLK      :   in STD_LOGIC;
              RESET    :   in STD_LOGIC;
              TABORTP  :   in STD_LOGIC;
              TAVAILP  :   in STD_LOGIC;
              TFINISHP :   in STD_LOGIC;
              TLASTP   :   in STD_LOGIC;
              TDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
              
              TREADDP  :   out STD_LOGIC;
              TRNSMTP  :   out STD_LOGIC;
              TSTARTP  :   out STD_LOGIC;
              TDONEP   :   out STD_LOGIC;
              TDATAO   :   out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
   component Collision
        Port ( CLK     :   in STD_LOGIC;
              RESET    :   in STD_LOGIC; 
              RCVNGP   :   in STD_LOGIC;
              TRNSMTP  :   in STD_LOGIC;
              
              TSOCOLP  :   out STD_LOGIC;
              RENABP   :   out STD_LOGIC;
              TABORTP  :   out STD_LOGIC);
    end component;
    
for all:Emetteur use entity work.Emetteur(behavioral);
for all:Recepteur use entity work.Recepteur(behavioral);
    
    signal rcvng, trnsmt, renab, tabort : STD_LOGIC;
    
begin

U1 : Emetteur port map(CLK10I,RESETN,tabort,TAVAILP,TFINISHP,TLASTP,TDATAI,TREADDP,trnsmt,TSTARTP,TDONEP,TDATAO);

U2 : Recepteur port map(CLK10I,RESETN,RBYTEP,RCLEANP,rcvng,RDATAO,RDATAI,RDONEP,RENABP,RSTARTP,RSMATIP);

U3 : Collision port map(CLK10I,RESETN,rcvng,trnsmt,renab,tabort);

TRNSMTP <= trnsmt;
RCVNGP  <= rcvng;

end struct;