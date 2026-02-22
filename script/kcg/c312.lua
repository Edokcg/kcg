--グランエルＡ3
local s, id = GetID()
function s.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)

	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon2)
	c:RegisterEffect(e1)

	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.eqcon)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_SZONE,0)
	e11:SetCode(EFFECT_EQUIP_MONSTER)
	e11:SetCondition(s.eecon)
	e11:SetTarget(s.eefilter)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e12)
	local e13=e11:Clone()
	e13:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e13)
end
s.listed_series={SET_MEKLORD_EMPEROR,SET_MEKLORD,0x507}

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,false,1,true,c,c:GetControler(),nil,false,nil,0x507)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,false,true,true,c,nil,nil,false,nil,0x507)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_MEKLORD_EMPEROR)
end
function s.sdcon2(e)
	return not Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.eecon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.eefilter(e,c)
	return c:IsFaceup() and c:GetEquipTarget() and c:IsOriginalType(TYPE_MONSTER) and c:GetEquipTarget():IsSetCard(SET_MEKLORD)
end

function s.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(SET_MEKLORD)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	  return eg:GetFirst():GetBattleTarget():IsControler(tp)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and eg:GetFirst():IsAbleToChangeControler()
			and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function s.eqlimit(e,c)
	  local tc2=e:GetLabelObject()
	  return c==tc2
	--return e:GetOwner()==c
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	if #g<1 then return end
	local tc2=g:GetFirst()
	local tc=eg:GetFirst()
	if tc:IsFaceup() then
		if tc2 then
			if not Duel.Equip(tp,tc,tc2,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(s.eqlimit)
			e1:SetLabelObject(tc2)
			tc:RegisterEffect(e1)
		end
	end
end