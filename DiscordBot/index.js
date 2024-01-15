// index.js

import { Client, GatewayIntentBits, Partials, REST, Routes } from 'discord.js';

//const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages] });

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
  ],
  partials: [Partials.Channel],
});

const token = 'MTE5NTQwMDIzNzM4MTA1ODYwMg.GW_lMa.ntzsPUMrbAnx6U5jkCJHAWEa1ia1wIcnM2e8GE';
const CLIENT_ID = '1195400237381058602';
//const GUILD_ID = '1102057486363676682'

client.on('ready', () => {
  console.log(`Logged in as ${client.user.tag}!`);
  // Set bot's activity status
  client.user.setActivity({
       type: "LISTENING",
       name: `Filthy Casuals`,
       //url: "https://www.twitch.tv/your_twitch_streaming" //optional
    });
});

client.on('messageCreate', (message) => {
  // Check for command with case sensitivity
  if (message.content === '!hello') {
    console.log('Responding to command', message.content);
    message.reply('Hello there!');
  }
});



////////////////////////////////////////////////////////////////
//const Rcon = require('rcon-client').Rcon;
import { Rcon } from 'rcon-client';

const rconConfig = {
  host: '51.161.86.207',
  port: 27961,
  password: 'dE3jpx1cGCPc',
};

client.on('messageCreate', async (message) => {
  // Check if the message is from a bot or not a command
  if (message.author.bot || !message.content.startsWith('!rcon')) {
    return;
  }

  // Extract the command and arguments
  const [command, ...args] = message.content.slice('!rcon'.length).trim().split(' ');

  // Construct the RCON command
  const rconCommand = `${command} ${args.join(' ')}`;

  try {
    // Connect to RCON
    const rcon = await Rcon.connect(rconConfig);

    // Send the RCON command
    const response = await rcon.send(rconCommand);

    // Reply to the Discord user with the RCON response
    message.reply(`RCON response: ${response}`);
  } catch (error) {
    console.error('Error connecting to RCON:', error);
    // Inform the Discord user about the error
    message.reply('Error connecting to RCON. Please try again later.');
  }
});

////////// LISTEN TO PLAYERS ONLY
const channelIdToUpdate = '1177045975232151582'; // Replace with the actual channel ID
let lastMessageId = null;

client.on('ready', () => {
  console.log(`Listening for RCON commands`);
  console.log(`Sending players list...`);

  // Schedule the RCON command every 30 seconds
  setInterval(() => {
    sendRconPlayersCommand();
  }, 3000);
});

async function sendRconPlayersCommand() {
  try {
    const rcon = await Rcon.connect(rconConfig);
    const response = await rcon.send('players');
    
    // Get the channel to update
    const channelToUpdate = client.channels.cache.get(channelIdToUpdate);

    if (channelToUpdate instanceof client.channels.TextChannel) {
      // Check if there's a previous message to edit
      if (lastMessageId) {
        const previousMessage = await channelToUpdate.messages.fetch(lastMessageId);
        if (previousMessage) {
          // Edit the previous message with the new RCON response
          await previousMessage.edit(`RCON Players: ${response}`);
          return;
        }
      }

      // Send a new message and update lastMessageId
      const newMessage = await channelToUpdate.send(`RCON Players: ${response}`);
      lastMessageId = newMessage.id;
    }

    // Close the RCON connection
    await rcon.end();
  } catch (error) {
    console.error('Error connecting to RCON:', error);
  }
}
//////////////////////////////LISTEN TO PLAYERS ONLY


////////////////////////////////////////////////////////////////
client.login(token);