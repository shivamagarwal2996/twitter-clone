// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"
// import {drawChart1, drawChart2} from "./loadChart"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()
let channel = socket.channel("room:lobby", {})

const addRowToBlocksTable = (payload) => {

}

const fillBlocksTable = (payload) => {
  let tbody = document.getElementById("blocks")
  console.log("tbody", tbody)
  console.log(payload)
  Object.keys(payload).map((key) => {
    let str = ''
    let tr = document.createElement('tr')
    tr.innerHTML = str += `${key}:  ${payload[key]} \n`
    tbody.appendChild(tr)
  })
  console.log("blocks_meta", payload)
  payload.blocks.map(addRowToBlocksTable)
  channel.on("new_block", addRowToBlocksTable)  //Subscribing to live blocks
}

export const getBlocks = () => {
  //Get all blocks that have been mined so far. Subscribing to live blocks later
  channel.push("get_blocks", {}, 10000)
    .receive("ok", fillBlocksTable)
    .receive("error", (reasons) => console.log("create failed", reasons) )
    .receive("timeout", () => console.log("Networking issue...") )
}

const fillBlocksTabl = (payload) => {
  let tbody = document.getElementById("users")
  console.log("tbody", tbody)
  console.log(payload)
  Object.keys(payload).map((key) => {
    let str = ''
    let tr = document.createElement('tr')
    tr.innerHTML = str += `${key}: ${payload[key]} \n`
    tbody.appendChild(tr)
  })
  console.log("blocks_meta", payload)
  payload.blocks.map(addRowToBlocksTable)
  channel.on("new_block", addRowToBlocksTable)  //Subscribing to live blocks
}

export const getUsers = () => {
  //Get all blocks that have been mined so far. Subscribing to live blocks later
  channel.push("get_users", {}, 10000)
    .receive("ok", fillBlocksTabl)
    .receive("error", (reasons) => console.log("create failed", reasons) )
    .receive("timeout", () => console.log("Networking issue...") )
}

// const fillCharts = (payload) => {
//   console.log("blocks_meta", payload)
//   let xValues = payload.blocks.map(block => block.height)
//   let yValues1 = payload.blocks.map(block => block.num_txns)
//   let yValues2 = payload.blocks.map(block => block.amount)
//   //Subscribing to live blocks
//   channel.on("new_block", ({height, num_txns, amount}) => {
//     xValues.push(height)
//     yValues1.push(num_txns)
//     yValues2.push(amount)
//     drawChart1(xValues, yValues1)
//     drawChart2(xValues, yValues2)
//   })
// }
//
// export const getChartData = () => {
//   //Getting all mined blocks
//   channel.push("get_blocks_meta", {}, 10000)
//   .receive("ok", fillCharts)
//   .receive("error", (reasons) => console.log("create failed", reasons) )
//   .receive("timeout", () => console.log("Networking issue...") )
// }
//
// let fillBlockTable = (block) => {
//   console.log("block received", block)
//   let {block_height, hash, merkle_root, nonce, prev_hash, target, timestamp, txns } = block
//   document.getElementById("num_txns").innerHTML = txns.length
//   document.getElementById("nonce").innerHTML = nonce
//   document.getElementById("target").innerHTML = target
//   document.getElementById("height").innerHTML = block_height
//   document.getElementById("timestamp").innerHTML = timestamp
//   document.getElementById("hash").innerHTML = hash
//   document.getElementById("merkle_root").innerHTML = merkle_root
//   document.getElementById("prev_hash").innerHTML = prev_hash
//   let transactions = document.getElementById("txns")
//   txns.forEach((txn) => {
//     let row = document.createElement("tr")
//     let cell = document.createElement("td")
//     cell.innerHTML = txn.hash
//     row.appendChild(cell)
//     transactions.appendChild(row)
//   })
//
// }
//
// export const getBlock = (blockHeight) => {
//   channel.push("get_block", {blockHeight}, 10000)
//     .receive("ok", fillBlockTable )
//     .receive("error", (reasons) => console.log("create failed", reasons) )
//     .receive("timeout", () => console.log("Networking issue...") )
// }

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

let blockData = document.querySelector("#block-data")
let hashData = document.querySelector("#hash-data")

export default socket
