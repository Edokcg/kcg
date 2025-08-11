--Number 92: Heart-eartH Dragon (Anime)
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,9,3)
	c:EnableReviveLimit()

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000368,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	--e3:SetCondition(s.rmcon)
	--e3:SetCost(s.rmcost)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)

	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(511000368,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCost(s.spcost)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)

	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511000368,2))
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.atkcon)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)

	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(511000368,3))
	e6:SetCategory(CATEGORY_POSITION)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(s.postg)
	e6:SetOperation(s.posop)
	c:RegisterEffect(e6)

	--Activate
	local e8=Effect.CreateEffect(c) 
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e8:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e8:SetCondition(s.damcon)
	e8:SetOperation(s.dam)
	e8:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e8)

	--recover
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(511000368,4))
	e7:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_BATTLED)
	e7:SetLabelObject(e8)
	e7:SetTarget(s.rectg)
	e7:SetOperation(s.recop)
	c:RegisterEffect(e7)

	--destroy replace
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EFFECT_DESTROY_REPLACE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(s.reptg)
	c:RegisterEffect(e9)
end
s.xyz_number=92
s.listed_series = {0x48}


function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c,e)
	return c:IsAbleToRemove() and c:GetRealFieldID()>e:GetHandler():GetFieldID()
	and c:GetTurnID()==Duel.GetTurnCount()-1
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil,e) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,240)==0 end
	Duel.RegisterFlagEffect(tp,240,0,0,0)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetOverlayCount()==0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*1000
	if atk>0 and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(function (e,c) return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED)*1000 end)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,0,0,0,false)
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

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	  local ttp=e:GetHandler():GetControler()
	return Duel.GetBattleDamage(ttp)>0
end
function s.dam(e,tp,eg,ep,ev,re,r,rp)
	local ttp=e:GetHandler():GetControler()
	e:SetLabel(Duel.GetBattleDamage(ttp))
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,ttp)
	--Duel.ChangeBattleDamage(ttp,0)
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():GetLabel()>0 end
	local ttp=e:GetHandler():GetControler()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-ttp,e:GetLabelObject():GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,ttp,e:GetLabelObject():GetLabel())
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local ttp=e:GetHandler():GetControler()
	if Duel.Damage(1-ttp,e:GetLabelObject():GetLabel(),REASON_EFFECT)>0 then
		Duel.Recover(ttp,e:GetLabelObject():GetLabel(),REASON_EFFECT)
	end
	e:GetLabelObject():SetLabel(0)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(13706,6)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
