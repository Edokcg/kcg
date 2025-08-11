--究极魔法圣结界
function c77239002.initial_effect(c)
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c77239002.activate)
	c:RegisterEffect(e1)

    --1回合1次不会战斗破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCountLimit(1)	
	e2:SetValue(c77239002.valcon)
	c:RegisterEffect(e2)
	
	--回血
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c77239002.condition3)	
	e3:SetTarget(c77239002.target3)
	e3:SetOperation(c77239002.operation3)
	c:RegisterEffect(e3)

	--对方怪兽不能直接攻击
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c77239002.condition4)	
	c:RegisterEffect(e4)
	
	--攻防上升
    local e5=Effect.CreateEffect(c)	
	e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetValue(1000)
    c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetValue(1000)
	c:RegisterEffect(e6)
	
	--贯穿伤害
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_PIERCE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e7)
	
    --自己场上攻击最低怪兽不能成为攻击目标	
	local e8=Effect.CreateEffect(c)       
	e8:SetType(EFFECT_TYPE_FIELD) 
	e8:SetRange(LOCATION_FZONE) 
	e8:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET) 
	e8:SetTargetRange(LOCATION_MZONE,0) 
	e8:SetCondition(c77239002.atkcon) 
	e8:SetTarget(c77239002.atktg) 
	e8:SetValue(Auxiliary.imval1)  
	c:RegisterEffect(e8)
	
	--战斗破坏时给予伤害
    local e9=Effect.CreateEffect(c)
    e9:SetCategory(CATEGORY_DAMAGE)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e9:SetCode(EVENT_BATTLE_DESTROYED)
    e9:SetRange(LOCATION_FZONE)
    e9:SetCondition(c77239002.condition9)
    e9:SetTarget(c77239002.target9)
    e9:SetOperation(c77239002.operation9)
    c:RegisterEffect(e9)

	--从双方所有区域特殊召唤
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(77239002,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_FZONE)
	e10:SetCountLimit(1)
	e10:SetTarget(c77239002.target10)
	e10:SetOperation(c77239002.operation10)
	c:RegisterEffect(e10)
	
	--持续公开手牌
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_PUBLIC)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTargetRange(0,LOCATION_HAND)	
	c:RegisterEffect(e11)

	--1000点伤害
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e12:SetCategory(CATEGORY_DAMAGE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e12:SetRange(LOCATION_FZONE)
    e12:SetCountLimit(1) 
	e12:SetCondition(c77239002.condition12)	
	e12:SetTarget(c77239002.target12)
	e12:SetOperation(c77239002.operation12)
	c:RegisterEffect(e12)

	--强制作出攻击
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_MUST_ATTACK)
	e13:SetRange(LOCATION_FZONE)
	e13:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e13)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_CANNOT_EP)
	e14:SetRange(LOCATION_FZONE)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(0,1)
	e14:SetCondition(c77239002.becon14)
	c:RegisterEffect(e14)

    --效果伤害无效
    local e15=Effect.CreateEffect(c)	
    e15:SetType(EFFECT_TYPE_QUICK_O)
    e15:SetRange(LOCATION_FZONE)
    e15:SetCode(EVENT_CHAINING)
    e15:SetCondition(c77239002.condition15)	
	e15:SetCost(c77239002.cost15)	
    e15:SetOperation(c77239002.operation15)
    c:RegisterEffect(e15)
	--战斗伤害无效
    local e16=Effect.CreateEffect(c)	
    e16:SetType(EFFECT_TYPE_QUICK_O)
    e16:SetRange(LOCATION_FZONE)
    e16:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e16:SetCondition(c77239002.damcon16)
    e16:SetCost(c77239002.damcost16)
    e16:SetOperation(c77239002.damop16)
    c:RegisterEffect(e16)

	--破坏对方3张卡
	local e17=Effect.CreateEffect(c)	
	e17:SetDescription(aux.Stringid(77239001,0))		
	e17:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e17:SetCategory(CATEGORY_DESTROY)
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_FZONE)
    e17:SetCountLimit(1) 
	e17:SetTarget(c77239002.target17)
	e17:SetOperation(c77239002.activate17)
	c:RegisterEffect(e17)
	
	--对方从卡组送10张卡去墓地
	local e18=Effect.CreateEffect(c)
	e18:SetDescription(aux.Stringid(77239001,3))	
	e18:SetType(EFFECT_TYPE_IGNITION)
	e18:SetCategory(CATEGORY_DECKDES)
	e18:SetRange(LOCATION_FZONE)
    e18:SetCountLimit(1) 
	e18:SetTarget(c77239002.distg18)
	e18:SetOperation(c77239002.disop18)
	c:RegisterEffect(e18)

	--从卡组选择1张魔陷加入手牌
	local e19=Effect.CreateEffect(c)
	e19:SetDescription(aux.Stringid(77239000,8))	
	e19:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e19:SetType(EFFECT_TYPE_IGNITION)
	e19:SetRange(LOCATION_FZONE)
	e19:SetCountLimit(1)	
    e19:SetTarget(c77239002.target19)
    e19:SetOperation(c77239002.activate19)
	c:RegisterEffect(e19)	
end
-----------------------------------------------------------------------------
function c77239002.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,77239002)~=0 then return end
	Duel.RegisterFlagEffect(tp,77239002,0,0,0)
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c77239002.checkop)
	e1:SetCountLimit(1)
    e1:SetRange(LOCATION_FZONE)	
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
    c:RegisterEffect(e1)
    c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,2)
	c77239002[c]=e1
end
function c77239002.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		--不受对方效果影响
	    local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetCode(EFFECT_IMMUNE_EFFECT)
	    e1:SetRange(LOCATION_FZONE)
	    e1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0)
	    e1:SetValue(c77239002.efilter)
	    c:RegisterEffect(e1)
	end
end
function c77239002.efilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end
-----------------------------------------------------------------------
function c77239002.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------------
function c77239002.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239002.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rec=Duel.GetLP(tp)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c77239002.operation3(e,tp,eg,ep,ev,re,r,rp)
	local rec=Duel.GetLP(tp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Recover(p,rec,REASON_EFFECT)
	end
end
------------------------------------------------------------------------
function c77239002.condition4(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0		
end
------------------------------------------------------------------------
function c77239002.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c77239002.atktg(e,c)
      local count=Duel.GetMatchingGroupCount(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return Duel.IsExistingMatchingCard(c77239002.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,count-1,c,c:GetAttack())
end
function c77239002.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
-----------------------------------------------------------------------
function c77239002.filter9(c,tp)
    return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp
end
function c77239002.condition9(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239002.filter9,1,nil,tp)
end
function c77239002.target9(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local dam=eg:Filter(c77239002.filter9,nil,tp):GetFirst():GetAttack()
    if dam<0 then dam=0 end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239002.operation9(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam=eg:Filter(c77239002.filter9,nil,tp):GetFirst():GetAttack()
    if dam<0 then dam=0 end
    Duel.Damage(p,dam,REASON_EFFECT)
end
-----------------------------------------------------------------------
function c77239002.filter10(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239002.target10(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239002.filter10,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239002.operation10(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local b1=Duel.IsExistingMatchingCard(c77239002.filter10,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c77239002.filter10,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (b1 or b2) then return end
	    local ops={}
	    local opval={}
	    local off=1
	    if b1 then
		ops[off]=aux.Stringid(77239002,0)
		opval[off-1]=1
		off=off+1
	    end
	    if b2 then
		ops[off]=aux.Stringid(77239002,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	    if opval[op]==1 then
		    local g=Duel.SelectMatchingCard(tp,c77239002.filter10,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		else
		   local rg=Duel.GetMatchingGroup(c77239002.filter10,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
		   Duel.ConfirmCards(tp,rg)
		   local tc=rg:Select(tp,1,1,nil)
		   Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end
-----------------------------------------------------------------------
function c77239002.condition12(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()==1-tp
end
function c77239002.target12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c77239002.operation12(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
-----------------------------------------------------------------------
function c77239002.befilter14(c)
	return c:IsType(TYPE_MONSTER)--c:IsAttackable()
end
function c77239002.becon14(e)
	return Duel.IsExistingMatchingCard(c77239002.befilter14,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
-----------------------------------------------------------------------
function c77239002.cost15(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c77239002.condition15(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
    local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
    if ex then return true end
    ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
    if not ex then return false end
    if cp~=PLAYER_ALL then return Duel.IsPlayerAffectedByEffect(cp,EFFECT_REVERSE_RECOVER)
    else return Duel.IsPlayerAffectedByEffect(0,EFFECT_REVERSE_RECOVER)
        or Duel.IsPlayerAffectedByEffect(1,EFFECT_REVERSE_RECOVER)
    end
end
function c77239002.operation15(e,tp,eg,ep,ev,re,r,rp)
    local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_REVERSE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetLabel(cid)
    e1:SetValue(c77239002.refcon)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
end
function c77239002.refcon(e,re,r,rp,rc)
    local cc=Duel.GetCurrentChain()
    if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
    local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
    return cid==e:GetLabel()
end
--------------------------------------------------------------------------
function c77239002.damcon16(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetBattleDamage(tp)>0
end
function c77239002.damcost16(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c77239002.damop16(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e1:SetOperation(c77239002.dop)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
end
function c77239002.dop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(tp,0)
end
--------------------------------------------------------------------------
function c77239002.filter17(c)
	return c:IsDestructable()
end
function c77239002.target17(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77239002.filter17(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c77239002.filter17,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239002.filter17,tp,0,LOCATION_ONFIELD,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239002.activate17(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77239002.distg18(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,10)
end
function c77239002.disop18(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.DiscardDeck(1-tp,10,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77239002.filter19(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c77239002.target19(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239002.filter19,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239002.activate19(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239002.filter19,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

