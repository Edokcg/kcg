--Number C5: Chaos Chimera Dragon
local s, id = GetID()
function s.initial_effect(c)
	aux.EnableCheckRankUp(c,nil,nil,90126061)
	--xyz summon
	Xyz.AddProcedure(c,nil,6,3,nil,nil,Xyz.InfiniteMats)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	 
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_CANNOT_ATTACK)
	e22:SetCondition(s.exattcon)
	c:RegisterEffect(e22)

	--attack cost
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetDescription(aux.Stringid(24696097,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(s.atkcost)
	e4:SetCondition(s.atkcon)
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4,false,EFFECT_MARKER_DETACH_XMAT)
	--back to deck
	local e46=Effect.CreateEffect(c)
	e46:SetCategory(CATEGORY_TODECK)
	e46:SetDescription(aux.Stringid(10406322,1))
	e46:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e46:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e46:SetCountLimit(1)
	e46:SetRange(LOCATION_MZONE)
	e46:SetTarget(s.tdtg)
	e46:SetOperation(s.tdop)
	c:RegisterEffect(e46)
	
	--multiattack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(s.atkvalue)
	c:RegisterEffect(e2) 
 
	--half damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(s.dcon)
	e5:SetOperation(s.dop)
	c:RegisterEffect(e5)

	--Attach Hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(55888045,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.negtg)
	e6:SetOperation(s.negop)
	e6:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e62=Effect.CreateEffect(c)
	e62:SetType(EFFECT_TYPE_SINGLE)
	e62:SetCode(EFFECT_RANKUP_EFFECT)
	e62:SetLabelObject(e6)
	c:RegisterEffect(e62)

	--Re-Attach
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(79094383,0))
	e7:SetCategory(CATEGORY_LEAVE_GRAVE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e7:SetProperty(EFFECT_FLAG_REPEAT)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(s.cost)
	e7:SetCondition(s.condition)
	e7:SetTarget(s.target)
	e7:SetOperation(s.operation)
	c:RegisterEffect(e7)
end
s.xyz_number=5
s.listed_series = {0x48}
s.listed_names={90126061}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.exattcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511010205)==0
end

function s.atkvalue(e,c) 
	return e:GetHandler():GetFlagEffect(511010205)-1
end

function s.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter,c:GetControler(),0,LOCATION_MZONE,1,c)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.filter(c,e,tp)
	return c:GetFlagEffect(13732)~=0 and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end

--atk 
function s.atkval(e,c)
	return c:GetOverlayCount()*1000
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47660516,0))   
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
	sg:GetFirst():RegisterFlagEffect(13732,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():GetFlagEffect(511010206)==0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ag=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
	if ag:GetCount()<1 then return end
	local g=ag:RandomSelect(tp,1)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	--Return removed card
	g:GetFirst():RegisterFlagEffect(5110205,RESET_PHASE+PHASE_END,0,1)
	--for check cannot attack
	c:RegisterFlagEffect(511010205,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE,0,1)
	--Avoid allow activate during attack
	c:RegisterFlagEffect(511010206,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE,0,1)
   
	--if c:GetAttackAnnouncedCount()>0 then Duel.ChainAttack() end

	local e10=Effect.CreateEffect(c)   
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_DAMAGE_STEP_END)
	e10:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
	e10:SetOperation(s.resetop)
	c:RegisterEffect(e10) 
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetFlagEffect(511010206)~=0 then
	e:GetHandler():ResetFlagEffect(511010206) end
end

function s.tdfilter(c)
	return c:IsAbleToDeck() and c:GetFlagEffect(5110205)~=0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,0,LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0,LOCATION_REMOVED,nil)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	--Duel.SortDecktop(tp,1-tp,g:GetCount())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_TRIGGER)
		tc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_SUMMON)
		tc:RegisterEffect(e6)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		tc:RegisterEffect(e7)
		local e8=e1:Clone()
		e8:SetCode(EFFECT_CANNOT_MSET)
		tc:RegisterEffect(e8)
		local e9=e1:Clone()
		e9:SetCode(EFFECT_CANNOT_SSET)
		tc:RegisterEffect(e9)
		tc=g:GetNext()
	end
end

--half damage
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end

--Attach Hand
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end