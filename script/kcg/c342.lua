--邪神官Chilam Sabak (K)
function c342.initial_effect(c)

	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123709,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c342.ntcon)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35699,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetTarget(c342.tg)
	e2:SetOperation(c342.op)
	c:RegisterEffect(e2)
end

function c342.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)>=5
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c342.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c342.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	  if ft<=0 then return end
	local c=e:GetHandler()
	  if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
 e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	  e0:SetValue(TYPE_TUNER)
	  e0:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e0,true) 
	  local e2=Effect.CreateEffect(c)
 e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	  e2:SetType(EFFECT_TYPE_SINGLE)
	  e2:SetCode(EFFECT_ADD_SETCODE)
	  e2:SetValue(0x301)
	  e2:SetReset(RESET_EVENT+0x1fe0000)
	  c:RegisterEffect(e2,true)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c342.synlimit)
	  e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	  Duel.SpecialSummonComplete()
	  end
end
function c342.synlimit(e,c)
if not c then return false end
	return not c:IsSetCard(0x301)
end
