--CNo.92 偽骸虚龍 Heart－eartH Chaos Dragon
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	aux.EnableCheckRankUp(c,nil,nil,84013237)
	Xyz.AddProcedure(c,nil,10,4)
	c:EnableReviveLimit()

	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	local ch=Effect.CreateEffect(c)
	ch:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	ch:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ch:SetCode(EVENT_BATTLE_DAMAGE)
	  ch:SetCondition(s.checkcon)
	ch:SetOperation(s.checkop)
	Duel.RegisterEffect(ch,0)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47017574,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_REPEAT+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	  e2:SetLabelObject(ch)
	e2:SetCondition(s.reccon)
	  e2:SetCountLimit(1)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	local ge2=Effect.CreateEffect(c) 
	  ge2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	  ge2:SetCode(EVENT_TURN_END)
	  ge2:SetCountLimit(1)
	ge2:SetOperation(s.checkop2) 
	  ge2:SetLabelObject(ch)
	  Duel.RegisterEffect(ge2,0)

	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47017574,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(Cost.DetachFromSelf(1))
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_RANKUP_EFFECT)
	e12:SetLabelObject(e3)
	c:RegisterEffect(e12)

	--   local e4=Effect.CreateEffect(c)
	-- e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)	  
	-- e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--   e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	--   e4:SetCondition(s.con)
	--   e4:SetOperation(s.op)
	--   c:RegisterEffect(e4)

	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(511000368,3))
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)	
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(s.con)
	e6:SetTarget(s.postg)
	e6:SetOperation(s.posop)
	c:RegisterEffect(e6)

	--remove
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(511000368,0))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	--e7:SetCondition(s.rmcon)
	e7:SetTarget(s.rmtg)
	e7:SetOperation(s.rmop)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_RANKUP_EFFECT)
	e11:SetLabelObject(e7)
	c:RegisterEffect(e11)

	--destroy replace
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EFFECT_DESTROY_REPLACE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(s.reptg)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_RANKUP_EFFECT)
	e10:SetLabelObject(e9)
	c:RegisterEffect(e10)
end
s.xyz_number=92
s.listed_series = {0x48}
s.listed_names={84013237}

function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	  return e:GetLabelObject():GetLabel()>0
	--return ep~=tp and eg:GetFirst():IsControler(tp)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabelObject():GetLabel())
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,e:GetLabelObject():GetLabel(),REASON_EFFECT)
	  e:GetLabelObject():SetLabel(0)
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT))
end
function s.filter2(c)
	return c:IsFacedown()
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsLocation(LOCATION_SZONE) and rc:IsFacedown()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_SZONE,1,nil) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	  local tc2=g2:GetFirst()
	while tc2 do
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_FIELD)
		  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		  e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		  e3:SetRange(LOCATION_MZONE)
		  e3:SetTargetRange(0,1)
		  e3:SetValue(s.aclimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		  c:RegisterEffect(e3)
		tc2=g2:GetNext()
	end
end

function s.con(e,tp,eg,ep,ev,re,r,rp) 
	  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and
	  (e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,97403510))
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	  e:GetHandler():RegisterFlagEffect(250,RESET_EVENT+0x1ff0000,0,1)
end

function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	  return ep==1-e:GetHandler():GetControler()
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local val=e:GetLabel()+ev
	e:SetLabel(val)
end

function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	  e:GetLabelObject():SetLabel(0)
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,0,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,true)
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(250)~=0
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.rmfilter(c,e)
	return c:IsAbleToRemove() and c:GetRealFieldID()>e:GetHandler():GetFieldID()
	and c:GetTurnID()==Duel.GetTurnCount()-1	
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_ONFIELD,1,nil,e) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(13706,6)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
